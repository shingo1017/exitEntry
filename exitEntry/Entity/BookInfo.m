//
//  BookInfo.m
//  copybook
//
//  Created by Shingo on 13-7-22.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "BookInfo.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"

static BookInfo *_defaultBookInfo;

@implementation BookInfo

+ (BookInfo *)defaultBookInfo {
    
    if (!_defaultBookInfo) {
        
        NSDictionary *loadData = [NSDictionary dictionaryWithContentsOfFile:FILE_SENDBOX_PATH(@"bookInfo")];
        _defaultBookInfo = [[BookInfo alloc] initWithDictionary:loadData error:nil];
        _defaultBookInfo.haveContract = [[NSUserDefaults standardUserDefaults] boolForKey:@"haveContract"];
//        NSArray *loadHouseRentalContractPhotos = [NSArray arrayWithContentsOfFile:FILE_SENDBOX_PATH(@"houseRentalContractPhotos")];
//        NSMutableArray *houseRentalContractPhotos = [NSMutableArray new];
//        for (NSString *url in _defaultBookInfo.houseRentalContractPhotos) {
//            
//            [houseRentalContractPhotos addObject:[NSURL URLWithString:url]];
//        }
//        _defaultBookInfo.houseRentalContractPhotos = houseRentalContractPhotos;
        
        if (!_defaultBookInfo) {
            
            _defaultBookInfo = [BookInfo new];
            _defaultBookInfo.haveContract = YES;
        }
    }
    
    return _defaultBookInfo;
}

+ (void)setDefaultBookInfo:(BookInfo *)bookInfo {
    
    _defaultBookInfo = bookInfo;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"myPhotoUrl" : @"avatar",
                                                                  @"passportPhotoUrl" : @"passport_image",
                                                                  @"identityType": @"credential_type",
                                                                  @"identityNumber" : @"credential",
                                                                  @"identityExpireDate" : @"credential_expired_date",
//                                                                  @"personType" : @"person_type",
//                                                                  @"personAreaType" : @"person_area_type",
                                                                  @"englishFirstName" : @"firstname",
                                                                  @"englishLastName" : @"lastname",
                                                                  @"name" : @"chinese_name",
                                                                  @"homeplace" : @"birthplace",
                                                                  @"workingOrganization" : @"working_organization",
                                                                  @"phoneNumber" : @"phone",
                                                                  @"emergencyContact": @"emergency_contact",
                                                                  @"emergencyContactPhoneNumber": @"emergency_phone",
                                                                  @"enterPhotoUrl": @"enter_image",
                                                                  @"visaPhotoUrl": @"visa_image",
                                                                  @"visaType": @"visa_type",
                                                                  @"visaExpireDate": @"visa_expired_date",
                                                                  @"enterDate": @"entry_date",
                                                                  @"entryPort": @"entry_port",
                                                                  @"stayReason": @"stay_reason",
                                                                  @"stayExpireDate": @"stay_expired_date",
                                                                  @"checkInDate": @"checkin_date",
                                                                  @"checkOutDate": @"checkout_date",
                                                                  @"houseAddress": @"house_address",
                                                                  @"landlordIdentityPhotoUrl" : @"landlord_identity_image",
                                                                  @"houseRentalContractPhotos" : @"house_contract_image",
//                                                                  @"policeStation": @"police_station",
                                                                  @"houseType": @"house_type",
                                                                  @"landlordCountry": @"landlord_country",
                                                                  @"landlordIdentityNumber": @"landlord_identity",
                                                                  @"landlordName": @"landlord_name",
                                                                  @"landlordGender": @"landlord_gender",
                                                                  @"landlordPhoneNumber": @"landlord_phone",
                                                                  @"rejectReason" : @"reject_reason",
                                                                  @"certificatePhotoUrl" : @"certificate_image",
                                                                  }];
}

- (NSString *)baseInfoVerification {
    
    NSString *errorMessage = @"";
    
    if (self.myPhotoUrl == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"本人照片"), text(@"不能为空")];
    else if (self.passportPhotoUrl == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"护照照片"), text(@"不能为空")];
    else if (self.country.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"国家"), text(@"不能为空")];
    else if (self.identityType.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"证件类型"), text(@"不能为空")];
    else if (self.identityNumber.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"证件号码"), text(@"不能为空")];
    else if (self.identityExpireDate == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"证件有效期"), text(@"不能为空")];
//    else if (self.personType.length == 0)
//        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"人员类型"), text(@"不能为空")];
//    else if (self.personAreaType.length == 0)
//        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"人员地域类型"), text(@"不能为空")];
    else if (self.englishLastName.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"英文姓"), text(@"不能为空")];
//    else if (self.gender.length == 0)
//        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"性别"), text(@"不能为空")];
//    else if (self.birthday == nil)
//        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"出生日期"), text(@"不能为空")];
    else if (self.homeplace.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"出生地"), text(@"不能为空")];
    else if (self.occupation.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"职业"), text(@"不能为空")];
    else if (self.workingOrganization.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"工作机构"), text(@"不能为空")];
    else if (self.phoneNumber.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"本人联系电话"), text(@"不能为空")];
    
    return errorMessage;
}

- (NSString *)visaInfoVerification {
    
    NSString *errorMessage = @"";
    
    if (!self.isGAT && self.enterPhotoUrl.absoluteString.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"入境照片"), text(@"不能为空")];
    else if (!self.isGAT && self.visaPhotoUrl.absoluteString.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"签证照片"), text(@"不能为空")];
    else if (!self.isGAT && self.visaType.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"签证（注）种类"), text(@"不能为空")];
    else if (!self.isGAT && self.visaExpireDate == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"签证（注）有效期"), text(@"不能为空")];
    else if (self.stayReason.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"停留事由"), text(@"不能为空")];
    
    return errorMessage;
}

- (NSString *)stayInfoVerification {
    
    NSString *errorMessage = @"";
    
//    if (self.checkInDate == nil)
//        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"入住日期"), text(@"不能为空")];
    if (self.checkOutDate == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"拟离开日期"), text(@"不能为空")];
    else if (self.houseAddress.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"详细地址"), text(@"不能为空")];
    else if (self.houseType.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房屋种类"), text(@"不能为空")];
    if (self.haveContract) {
        
        //有合同
        if (self.landlordIdentityPhotoUrl.absoluteString.length == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房主身份证照片"), text(@"不能为空")];
        else if (self.houseRentalContractPhotos.count == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房屋租赁合同照片"), text(@"不能为空")];
    }
    else {
        
        //没合同
        //    else if (self.policeStation.length == 0)
        //        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"所属派出所"), text(@"不能为空")];
        if (self.landlordCountry.length == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房主国家"), text(@"不能为空")];
        else if (self.landlordIdentityNumber.length == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房主身份证号"), text(@"不能为空")];
        else if (self.landlordName.length == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房主中文姓名"), text(@"不能为空")];
        else if (self.landlordPhoneNumber.length == 0)
            errorMessage = [NSString stringWithFormat:@"%@%@", text(@"房主联系电话"), text(@"不能为空")];
    }
    
    return errorMessage;
}

- (NSString *)writeOffVerification {
    
    NSString *errorMessage = @"";
    
    if (self.leaveCountryDate == nil)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"离开日期"), text(@"不能为空")];
    else if (self.leaveReason.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"离开原因"), text(@"不能为空")];
    else if (self.whereToGo.length == 0)
        errorMessage = [NSString stringWithFormat:@"%@%@", text(@"去往目的地"), text(@"不能为空")];
    
    return errorMessage;
}

- (BOOL)isGAT {
    
    if ([_identityType isEqualToString:@"11"] || [_identityType isEqualToString:@"7"] || [_identityType isEqualToString:@"1"])
        return YES;
    else
        return NO;
}

- (void)prepareSubmit {
    
    if (!_englishFirstName)
        _englishFirstName = @"";
    if (!_name)
        _name = @"";
    if (!_emergencyContact)
        _emergencyContact = @"";
    if (!_emergencyContactPhoneNumber)
        _emergencyContactPhoneNumber = @"";
//    if (!_enterDate)
//        _enterDate = [NSDate dateWithTimeIntervalSince1970:0];
//    if (!_entryPort)
//        _entryPort = @"";
//    if (!_stayExpireDate)
//        _stayExpireDate = [NSDate dateWithTimeIntervalSince1970:0];
//    if (!_community)
//        _community = @"";
    if (!_houseType)
        _houseType = @"";
    if (!_landlordGender)
        _landlordGender = @"";
}

- (void)save {
    
    [[NSUserDefaults standardUserDefaults] setBool:_defaultBookInfo.haveContract forKey:@"haveContract"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *saveData = [[NSMutableDictionary alloc] initWithDictionary:[self toDictionary]];
    
//    NSMutableArray *houseRentalContractPhotos = [NSMutableArray new];
//    for (NSURL *url in saveData[@"houseRentalContractPhotos"]) {
//        
//        [houseRentalContractPhotos addObject:[url absoluteString]];
//    }
//    saveData[@"houseRentalContractPhotos"] = houseRentalContractPhotos;
    [saveData writeToFile:FILE_SENDBOX_PATH(@"bookInfo") atomically:YES];

//    [houseRentalContractPhotos writeToFile:FILE_SENDBOX_PATH(@"houseRentalContractPhotos") atomically:YES];
//    NSArray *loadData = [NSArray arrayWithContentsOfFile:FILE_SENDBOX_PATH(@"houseRentalContractPhotos")];
//    NSLog(@"%@", loadData);
}

- (void)delete {
    
    [[NSFileManager defaultManager] removeItemAtPath:FILE_SENDBOX_PATH(@"bookInfo") error:nil];
}

@end
