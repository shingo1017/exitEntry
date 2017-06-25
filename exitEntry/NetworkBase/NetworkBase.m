//
//  NetworkBase.m
//  copybook
//
//  Created by heyz3a on 16/11/3.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "NetworkBase.h"
//#import "UIDevice+IdentifierAddition.h"
//#import "sys/utsname.h"

@implementation NetworkBase


- (void)dealloc {
    NSLog(@"Dealloc on Network Base of :%@", NSStringFromClass([self class]));
}

- (void)requestWithParams:(NSDictionary *)params {
    // implement by sub class
}

- (void)handleResponse:(id)response withError:(NSError *)error {

    if (nil != error) {
        //TODO: handle error code and reason with multiply situation
        if (nil != self.failBlock) {
            self.failBlock(error.code, error.code == NSURLErrorTimedOut ? @"请求超时" : @"加载失败");
        }
        return;
    }
    if (nil == response) {
        if (nil != self.failBlock) {
            self.failBlock(NSURLErrorUnknown, @"加载失败");
        }
        return;
    }

    NSError *parseError = nil;
    id data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted
                                                error:&parseError];
    if (nil != parseError || nil == data) {
        NSLog(@"Error when parsing json get response with url:%@ \n error:%@", self.requestURL, error.debugDescription);

        if (nil != self.failBlock) {
            self.failBlock(NSURLErrorUnknown, @"加载失败");
        }
        return;
    }
    NSString *perttyPrintStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@" Response url:%@ with result:\n %@", self.requestURL, perttyPrintStr);


    if ([self respondsToSelector:@selector(handleResponse:)]) {
        [self handleResponse:response];
    }

}

- (void)handleResponse:(id)response {
    // implement by sub class
}

- (NSDictionary *)commonHeader {
    
    NSString *lan = ((AppDelegate *)[UIApplication sharedApplication].delegate).language;
    if ([lan isEqualToString:@"zh-Hans"])
        lan = @"zh-CN";
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).language.length > 0)
        return @{ @"Accept": @"application/json", @"Accept-Language": lan };
    else
        return @{};
}

- (void)startRequest {

    NSLog(@"Request with url :%@ \n params: %@ \n", self.requestURL, self.params);


    void (^failedBlock)(NSError *error)= ^(NSError *error) {

        NSString *methodName = @"Requesting";
        switch (self.method) {
            case NetworkBaseMethodGet: {
                methodName = @"Getting";
            }
                break;
            case NetworkBaseMethodPost: {
                methodName = @"Posting";
            }
                break;
            case NetworkBaseMethodPut: {
                methodName = @"Putting";
            }
                break;
            case NetworkBaseMethodDelete: {
                methodName = @"Deleting";
            }
                break;
            case NetworkBaseMethodUpload: {

                methodName = @"Uploading";
            }
                break;
            default:
                break;
        }
        NSLog(@"Error %@ with url:%@ \n %@", methodName, self.requestURL, error.debugDescription);

        if ([self respondsToSelector:@selector(handleResponse:withError:)]) {
            [self handleResponse:nil withError:error];
        }

    };//end of define failedBlock

    void (^successBlock)(id responseObject) = ^(id responseObject) {

        if ([self respondsToSelector:@selector(handleResponse:withError:)]) {
            [self handleResponse:responseObject withError:nil];
        }

    };//end of define success block

    //setup headers
    NSMutableDictionary *headers = [NSMutableDictionary new];

    if (self.httpHeaderField)
        [headers addEntriesFromDictionary:self.httpHeaderField];
    else
        [headers addEntriesFromDictionary:self.commonHeader];

    //set headers
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }];

    NSLog(@"And with http header field :%@", headers);

    [self.sessionManager.requestSerializer setTimeoutInterval:500.0f];

    AFHTTPResponseSerializer *responseSerializer;

    if (self.method == NetworkBaseMethodGet) {

        responseSerializer = [AFJSONResponseSerializer serializer];
        [self.sessionManager setResponseSerializer:responseSerializer];


//        [self.sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];

        [self.sessionManager GET:self.requestURL parameters:self.params progress:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             successBlock(responseObject);
                         }
                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                             failedBlock(error);
                         }];

    }//JSON Get


    if (self.method == NetworkBaseMethodPost) {

        responseSerializer = [AFJSONResponseSerializer serializer];
        [self.sessionManager setResponseSerializer:responseSerializer];


        [self.sessionManager POST:self.requestURL parameters:self.params progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              successBlock(responseObject);
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              failedBlock(error);

                          }];
    }//JSON POST

    if (self.method == NetworkBaseMethodPut) {

        responseSerializer = [AFJSONResponseSerializer serializer];
        [self.sessionManager setResponseSerializer:responseSerializer];

        [self.sessionManager PUT:self.requestURL parameters:self.params
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             successBlock(responseObject);
                         }
                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                             failedBlock(error);
                         }];

    }//PUT


    if (self.method == NetworkBaseMethodDelete) {

        responseSerializer = [AFJSONResponseSerializer serializer];
        [self.sessionManager setResponseSerializer:responseSerializer];

        [self.sessionManager DELETE:self.requestURL parameters:self.params
                            success:^(NSURLSessionDataTask *task, id responseObject) {

                                successBlock(responseObject);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                failedBlock(error);
                            }];

    }//Delete

    if (self.method == NetworkBaseMethodUpload) {


        // Need to set longer timeout interval in case if request end before response received


        [self.sessionManager POST:self.requestURL parameters:self.params constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(self.uploadImages[0], 0.5f);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.png" mimeType:@"image/png"];

        }                progress:^(NSProgress *uploadProgress) {
            NSLog(@"uploadProgress = %@", uploadProgress);
            if (nil != self.progressBlock) {
                self.progressBlock(uploadProgress);
            }
        }                 success:^(NSURLSessionDataTask *task, id responseObject) {
            successBlock(responseObject);
        }                 failure:^(NSURLSessionDataTask *task, NSError *error) {
            failedBlock(error);
        }];
    }//upload single files


    if (self.method == NetworkBaseMethodUploadMultiFiles) {

        [self.sessionManager.requestSerializer setTimeoutInterval:500.0f];

        [self.sessionManager POST:self.requestURL parameters:self.params constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
            __block NSString *uploadKey = @"fileList";
            [self.uploadImages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {

                NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                [formData appendPartWithFileData:imageData name:uploadKey fileName:[NSString stringWithFormat:@"image-%@.png", @(idx)] mimeType:@"image/png"];

            }];// end of append with multiply images

        }                progress:^(NSProgress *uploadProgress) {
            NSLog(@"uploadProgress = %@", uploadProgress);
            if (nil != self.progressBlock) {
                self.progressBlock(uploadProgress);
            }
        }                 success:^(NSURLSessionDataTask *task, id responseObject) {
            successBlock(responseObject);
        }                 failure:^(NSURLSessionDataTask *task, NSError *error) {
            failedBlock(error);
        }];

    }

}

//- (NSDictionary *)trackingHeader {
//
//    NSDictionary *header = @{
//            @"_installment_id": [[UIDevice currentDevice] uniqueDeviceIdentifier],
//            @"_platform": @"iOS",
//            @"_device": [self getDeviceModel],
//            @"_os_version": [[UIDevice currentDevice] systemVersion],
//            @"_app_version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
//            @"_lang": [[NSLocale preferredLanguages] firstObject],
//    };
//
//    return header;
//}

//- (NSString *)getDeviceModel {
//
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//}

#pragma mark - Public Method for custom http Header field

+ (NSDictionary *)commonHeaderWithLanguage:(NSString *)language {
    
    NSDictionary *header = @{
                             @"Accept-Language": language,
                             };
    
    return header;
}

+ (NSDictionary *)authorizedHeader {

    NSString *lan = ((AppDelegate *)[UIApplication sharedApplication].delegate).language;
    if ([lan isEqualToString:@"zh-Hans"])
        lan = @"zh-CN";
    
    NSDictionary *header = @{
            @"Accept": @"application/json",
            @"Authorization": [NSString stringWithFormat:@"Bearer %@", [User defaultUser].apiKey],
            @"Accept-Language": lan,
    };

    return header;
}

+ (NSDictionary *)uploadHeader {

    NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:[NSString stringWithFormat:@"Bearer %@", [User defaultUser].apiKey] forKey:@"Authorization"];
    [headerFields setValue:((AppDelegate *)[UIApplication sharedApplication].delegate).language forKey:@"Accept-Language"];
    [headerFields setValue:contentType forKey:@"Content-Type"];

    return headerFields;
}

#pragma mark - Properties

- (AFHTTPSessionManager *)sessionManager {
    if (nil == _sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:Server_URL]];

        AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
        [requestSerializer setTimeoutInterval:5.0f];

        [_sessionManager setRequestSerializer:requestSerializer];

        AFHTTPResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];

        [_sessionManager setResponseSerializer:responseSerializer];

    }
    return _sessionManager;
}


@end
