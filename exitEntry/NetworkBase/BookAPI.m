//
//  BookAPI.m
//  copybook
//
//  Created by 尹楠 on 16/11/7.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "BookAPI.h"

//登记资料
#define SUBMIT_INFO_URL                 @"api/user/%@/registrant"
//修改登记资料
#define EDIT_INFO_URL                   @"api/user/%@/registrant/%zi"
//获取用户详情
#define GET_BOOK_STATUS_URL             @"api/user/%@/registrant"
//上传单张图片
#define UPLOAD_PHOTO_URL                @"api/upload"
//核销信息
#define WRITE_OFF_URL                   @"api/user/%@/registrant/%zi"

@implementation BookAPI

- (void)getBookStatus {
    
    self.requestURL = [NSString stringWithFormat:GET_BOOK_STATUS_URL, [User defaultUser].id];
    self.method = NetworkBaseMethodGet;
    self.httpHeaderField = [NetworkBase authorizedHeader];
    
    [self startRequest];
}

- (void)uploadPhoto:(UIImage *)photo {
    
    self.requestURL = UPLOAD_PHOTO_URL;
    self.uploadImages = @[photo];
    self.method = NetworkBaseMethodUpload;
    self.httpHeaderField = [NetworkBase uploadHeader];
    
    [self startRequest];
}

- (void)submitInfo {
    
    if ([User defaultUser].bookStatus == BookStatusNotSubmit) {
        
        self.requestURL = [NSString stringWithFormat:SUBMIT_INFO_URL, [User defaultUser].id];
        self.method = NetworkBaseMethodPost;
    }
    else {
        
        self.requestURL = [NSString stringWithFormat:EDIT_INFO_URL, [User defaultUser].id, [BookInfo defaultBookInfo].id];
        self.method = NetworkBaseMethodPut;
    }
    
    self.httpHeaderField = [NetworkBase authorizedHeader];
    
    [[BookInfo defaultBookInfo] prepareSubmit];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                        @"avatar" : [[[BookInfo defaultBookInfo].myPhotoUrl absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"passport_image" : [[[BookInfo defaultBookInfo].passportPhotoUrl absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"country" : [BookInfo defaultBookInfo].country,
                        @"credential_type" : [BookInfo defaultBookInfo].identityType,
                        @"credential" : [BookInfo defaultBookInfo].identityNumber,
                        @"credential_expired_date" : [[BookInfo defaultBookInfo].identityExpireDate stringValue],
//                        @"person_type" : [BookInfo defaultBookInfo].personType,
//                        @"person_area_type" : [BookInfo defaultBookInfo].personAreaType,
                        @"firstname" : [BookInfo defaultBookInfo].englishFirstName,
                        @"lastname" : [BookInfo defaultBookInfo].englishLastName,
                        @"chinese_name" : [BookInfo defaultBookInfo].name,
//                        @"gender" : [BookInfo defaultBookInfo].gender,
//                        @"birthday" : [[BookInfo defaultBookInfo].birthday stringValue],
                        @"birthplace" : [BookInfo defaultBookInfo].homeplace,
                        @"occupation" : [BookInfo defaultBookInfo].occupation,
                        @"working_organization" : [BookInfo defaultBookInfo].workingOrganization,
                        @"phone" : [BookInfo defaultBookInfo].phoneNumber,
                        @"emergency_contact" : [BookInfo defaultBookInfo].emergencyContact,
                        @"emergency_phone" : [BookInfo defaultBookInfo].emergencyContactPhoneNumber,
//                        @"entry_date" : [[BookInfo defaultBookInfo].enterDate stringValue],
//                        @"entry_port" : [BookInfo defaultBookInfo].entryPort,
                        @"stay_reason" : [BookInfo defaultBookInfo].stayReason,
//                        @"stay_expired_date" : [[BookInfo defaultBookInfo].stayExpireDate stringValue],
//                        @"checkin_date" : [[BookInfo defaultBookInfo].checkInDate stringValue],
                        @"checkout_date" : [[BookInfo defaultBookInfo].checkOutDate stringValue],
                        @"house_address" : [BookInfo defaultBookInfo].houseAddress,
                        @"house_type" : [BookInfo defaultBookInfo].houseType,
//                        @"police_station" : [BookInfo defaultBookInfo].policeStation,
//                        @"community" : [BookInfo defaultBookInfo].community,
                        }];
    
    if (![[BookInfo defaultBookInfo] isGAT]) {
        
        [param setObject:[[[BookInfo defaultBookInfo].enterPhotoUrl absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"enter_image"];
        [param setObject:[[[BookInfo defaultBookInfo].visaPhotoUrl absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"visa_image"];
        [param setObject:[BookInfo defaultBookInfo].visaType forKey:@"visa_type"];
        [param setObject:[[BookInfo defaultBookInfo].visaExpireDate stringValue] forKey:@"visa_expired_date"];
    }
    
    if ([BookInfo defaultBookInfo].haveContract) {
        
        param[@"landlord_identity_image"] = [[BookInfo defaultBookInfo].landlordIdentityPhotoUrl absoluteString];
        param[@"house_contract_image"] = [BookInfo defaultBookInfo].houseRentalContractPhotos;
    }
    else {
        
        param[@"landlord_country"] = [BookInfo defaultBookInfo].landlordCountry;
        param[@"landlord_identity"] = [BookInfo defaultBookInfo].landlordIdentityNumber;
        param[@"landlord_name"] = [BookInfo defaultBookInfo].landlordName;
        param[@"landlord_gender"] = [BookInfo defaultBookInfo].landlordGender;
        param[@"landlord_phone"] = [BookInfo defaultBookInfo].landlordPhoneNumber;
    }
    
    self.params = param;
    
    [self startRequest];
}

- (void)writeOffInfo {
    
    self.requestURL = [NSString stringWithFormat:WRITE_OFF_URL, [User defaultUser].id, [BookInfo defaultBookInfo].id];
    self.method = NetworkBaseMethodDelete;
    self.httpHeaderField = [NetworkBase authorizedHeader];
    
    NSDictionary *p = @{
                        @"leave_date" : [[BookInfo defaultBookInfo].leaveCountryDate stringValue],
                        @"leave_reason" : [BookInfo defaultBookInfo].leaveReason,
                        @"destination" : [BookInfo defaultBookInfo].whereToGo,
                        };
    self.params = p;
    
    [self startRequest];
}

- (NSData *)arrayOrNSDictionaryToNSData:(NSDictionary *)dic
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSString*) urlEncodedKeyValueString:(NSDictionary *)dic {
    
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in dic) {
        
        NSObject *value = [dic valueForKey:key];
        if([value isKindOfClass:[NSString class]])
            [string appendFormat:@"%@=%@&", [key urlEncodedString], [((NSString*)value) urlEncodedString]];
        else
            [string appendFormat:@"%@=%@&", [key urlEncodedString], value];
    }
    
    if([string length] > 0)
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    
    return string;
}

@end
