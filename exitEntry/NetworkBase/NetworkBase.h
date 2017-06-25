//
//  NetworkBase.h
//  copybook
//
//  Created by heyz3a on 16/11/3.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking/AFNetworking.h"

typedef NS_ENUM(NSUInteger, NetworkBaseMethod) {
    NetworkBaseMethodGet = 0,
    NetworkBaseMethodPost = 1,
    NetworkBaseMethodPut = 2,
    NetworkBaseMethodDelete = 3,
    NetworkBaseMethodUpload = 4,
    NetworkBaseMethodUploadMultiFiles = 5
};

typedef void (^NWBaseSuccessBlock)(id result);

typedef void (^NWBaseFailBlock)(NSInteger errorCode, NSString *errorReason);

typedef void (^NWBaseProgressBlock)(NSProgress *progress);

@interface NetworkBase : NSObject


@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, copy) NWBaseSuccessBlock successBlock;
@property(nonatomic, copy) NWBaseFailBlock failBlock;
@property(nonatomic, copy) NWBaseProgressBlock progressBlock;

@property(nonatomic, strong) NSString *requestURL;
@property(nonatomic, strong) NSDictionary *params;

@property(nonatomic, assign) NetworkBaseMethod method;

@property(nonatomic, strong) NSDictionary *httpHeaderField;

@property(nonatomic, strong) NSArray *uploadImages;
//@property(nonatomic, strong) NSData *uploadData;


- (void)requestWithParams:(NSDictionary *)params;

- (void)handleResponse:(id)response withError:(NSError *)error;

- (void)handleResponse:(id)response;

- (void)startRequest;

+ (NSDictionary *)commonHeaderWithLanguage:(NSString *)language;
+ (NSDictionary *)authorizedHeader;

+ (NSDictionary *)uploadHeader;


@end
