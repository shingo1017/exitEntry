//
//  LoginAPI.h
//  copybook
//
//  Created by heyz3a on 16/11/3.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "NetworkBase.h"
#import "CommonAPI.h"

@protocol LoginDelegate;

@interface LoginAPI : CommonAPI

@property (nonatomic, weak) IBOutlet id<LoginDelegate> delegate;

+ (LoginAPI *)sharedInstance;

- (void)sendVerifyCode:(NSString *)phoneNumber;
- (void)loginWithPhoneNumber:(NSString *)phoneNumber verifyCode:(NSString *)verifyCode;
- (void)refreshBookStatus;
- (void)autoLogin;
- (void)registerDevice;

@end

@protocol LoginDelegate <NSObject>

- (void)didFinishLogin:(LoginAPI *)loginAPI;
- (void)didFailedLogin:(LoginAPI *)loginAPI;

@end
