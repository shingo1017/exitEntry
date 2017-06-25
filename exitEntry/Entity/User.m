//
//  User.m
//  copybook
//
//  Created by Shingo on 13-7-22.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "User.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"
#import "BookInfo.h"

static User *_defaultUser;

@implementation User

+ (User *)defaultUser {
    
    if (!_defaultUser) {
        
        _defaultUser = [User new];
        _defaultUser.bookStatus = BookStatusNotSubmit;
    }
    
    return _defaultUser;
}

+ (void)setDefaultUser:(User *)user {
    
    _defaultUser = user;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"id",
                                                                  @"phoneNumber": @"phone",
                                                                  }];
}

+ (BOOL)checkPermission {
    
    if ([User defaultUser] && [User defaultUser].id.length > 0 && [User defaultUser].apiKey.length > 0)
        return YES;
    else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_SHOW_LOGIN_NOTIFICATION object:nil];
        return NO;
    }
}

+ (BOOL)isLogin {
    
    if ([User defaultUser] && [User defaultUser].id.length > 0 && [User defaultUser].apiKey.length > 0)
        return YES;
    else
        return NO;
}

- (NSString *)name {
    
    if ((self.bookStatus == BookStatusApproved || self.bookStatus == BookStatusCertificateReady) && [BookInfo defaultBookInfo].name.length > 0)
        _name = [BookInfo defaultBookInfo].name;
    else if ([BookInfo defaultBookInfo].englishFirstName.length > 0 && [BookInfo defaultBookInfo].englishLastName.length > 0)
        _name = [NSString stringWithFormat:@"%@ %@", [BookInfo defaultBookInfo].englishFirstName, [BookInfo defaultBookInfo].englishLastName];
    else if ([BookInfo defaultBookInfo].englishFirstName.length > 0 && [BookInfo defaultBookInfo].englishLastName.length == 0)
        _name = [BookInfo defaultBookInfo].englishFirstName;
    else if ([BookInfo defaultBookInfo].englishFirstName.length > 0 || [BookInfo defaultBookInfo].englishLastName.length > 0)
        _name = [BookInfo defaultBookInfo].englishLastName;
    else if ([BookInfo defaultBookInfo].phoneNumber.length > 0)
        _name = [NSString stringWithFormat:@"%@ %@", [BookInfo defaultBookInfo].phoneNumber, text(@"手机用户")];
    else
        _name = text(@"游客");
    
    return _name;
}

- (NSString *)bookStatusText {
    
    if (self.bookStatus == BookStatusNotSubmit)
        _bookStatusText = text(@"未提交资料");
    else if (self.bookStatus == BookStatusWatingForReview)
        _bookStatusText = text(@"等待审核");
    else if (self.bookStatus == BookStatusInReview)
        _bookStatusText = text(@"审核中");
    else if (self.bookStatus == BookStatusApproved)
        _bookStatusText = text(@"审核通过");
    else if (self.bookStatus == BookStatusCertificateReady)
        _bookStatusText = text(@"审核通过");
//        _bookStatusText = text(@"电子证书可下载");
    else if (self.bookStatus == BookStatusRejected)
        _bookStatusText = text(@"申请被拒绝");
    
    return _bookStatusText;
}

@end
