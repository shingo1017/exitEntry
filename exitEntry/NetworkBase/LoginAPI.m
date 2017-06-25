//
//  LoginAPI.m
//  copybook
//
//  Created by heyz3a on 16/11/3.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "LoginAPI.h"
#import "UIDevice+IdentifierAddition.h"
#import "JPUSHService.h"
#import "BookAPI.h"

static LoginAPI *_sharedInstance;

//获取验证码
#define SEND_VERIFY_CODE_URL            @"api/sms"
//登录
#define LOGIN_URL                       @"api/login"
//绑定设备
#define REGESTER_DEVICE_URL             @"device/ios/%@/?udid=%@&release=%@"

@implementation LoginAPI

+ (LoginAPI *)sharedInstance {
    
    if (!_sharedInstance)
        _sharedInstance = [LoginAPI new];
    
    return _sharedInstance;
}

- (void)sendVerifyCode:(NSString *)phoneNumber {
    
    self.requestURL = SEND_VERIFY_CODE_URL;
    self.method = NetworkBaseMethodPost;
    self.params = @{ @"phone" : phoneNumber };
    
    [self startRequest];
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber verifyCode:(NSString *)verifyCode {
    
    @weakify(self)
    [self setSuccessBlock:^(id result) {
        
        @strongify(self)
        
        User *user = [[User alloc] initWithDictionary:result[@"user"] error:nil];
        user.apiKey = result[@"token"];
        //            user.bookStatus = [result[@"status"] integerValue];
        [User setDefaultUser:user];
        
        [JPUSHService setAlias:phoneNumber callbackSelector:nil object:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aliased"];
        
        
        BookAPI *bookAPI = [BookAPI new];
        [bookAPI setSuccessBlock:^(id result) {
            
            BookInfo *bookInfo = [[BookInfo alloc] initWithDictionary:result error:nil];
            if (bookInfo) {
                
                bookInfo.haveContract = [[NSUserDefaults standardUserDefaults] boolForKey:@"haveContract"];
                [BookInfo setDefaultBookInfo:bookInfo];
                [User defaultUser].bookStatus = [result[@"status"] integerValue];
            }
            else
                [User defaultUser].bookStatus = BookStatusNotSubmit;
            
            if (![phoneNumber isEqualToString:PHONENUMBER]) {
                
                [[BookInfo defaultBookInfo] delete];
                [BookInfo setDefaultBookInfo:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_DID_LOGIN_NOTIFICATION object:nil];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLogin:)])
                [self.delegate didFinishLogin:self];
        }];
        [bookAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedLogin:)])
                [self.delegate didFailedLogin:self];
        }];
        [bookAPI getBookStatus];
        
        //            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"deviceRegistered"] == NO) {
        
        //the device did not register.
        //banding device for push notification.
        //                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
        
        //                    LoginAPI *loginAPI = [LoginAPI new];
        //                    [loginAPI setSuccessBlock:^(id result) {
        //
        //                        [UserDefaults setBool:YES forKey:@"deviceRegistered"];
        //                    }];
        //                    [loginAPI registerDevice];
        //                }
    }];
    [self setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
        
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedLogin:)])
            [self.delegate didFailedLogin:self];
    }];
    
    self.requestURL = LOGIN_URL;
    self.method = NetworkBaseMethodPost;
    self.params = @{
                    @"phone" : phoneNumber,
                    @"verify_code" : verifyCode,
                    };
    
    [self startRequest];
}

- (void)refreshBookStatus {
    
    BookAPI *bookAPI = [BookAPI new];
    [bookAPI setSuccessBlock:^(id result) {
        
        BookInfo *bookInfo = [[BookInfo alloc] initWithDictionary:result error:nil];
        if (bookInfo) {
            
            bookInfo.haveContract = [[NSUserDefaults standardUserDefaults] boolForKey:@"haveContract"];
            [BookInfo setDefaultBookInfo:bookInfo];
            [User defaultUser].bookStatus = [result[@"status"] integerValue];
        }
        else
            [User defaultUser].bookStatus = BookStatusNotSubmit;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_RELOAD_STATUS_NOTIFICATION object:nil];
    }];
    [bookAPI getBookStatus];
}

- (void)autoLogin {
    
    NSString *phoneNumber = PHONENUMBER;
    if (phoneNumber.length > 0) {
        
        [self loginWithPhoneNumber:phoneNumber verifyCode:@"123123"];
    }
    else {
        
        if (_delegate && [_delegate respondsToSelector:@selector(didFailedLogin:)])
            [_delegate didFailedLogin:self];
    }
}

- (void)registerDevice {
    
    //TODO:enterprise change to appstore
    self.requestURL = [NSString stringWithFormat:REGESTER_DEVICE_URL, [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"], [UIDevice currentDevice].uniqueDeviceIdentifier, @"enterprise"];
    self.method = NetworkBaseMethodPost;
    self.httpHeaderField = [NetworkBase authorizedHeader];
    
    [self startRequest];
}

@end
