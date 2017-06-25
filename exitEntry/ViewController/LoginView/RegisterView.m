
//
//  RegisterView.m
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import "RegisterView.h"
#import "LoginAPI.h"
#import "BookAPI.h"
#import "JPUSHService.h"

@interface RegisterView () <LoginDelegate> {
    
    NSString *_validateCode;
    NSString *_validateId;
    NSInteger _seconds;
}

@end

@implementation RegisterView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;

    navigationBarWidget.title = text(@"登录");
    navigationBarWidget.delegate = self;
    
    [phoneNumberContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    phoneNumberCaption.text = text(@"手机号");
    phoneNumberText.textColor = TITLE_COLOR;
    phoneNumberText.placeholder = text(@"请输入手机号");
    [verifyCodeContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    verifyCodeCaption.text = text(@"验证码");
    verifyCodeText.textColor = TITLE_COLOR;
    verifyCodeText.placeholder = text(@"请输入验证码");
    [verifyCodeButton setTitle:text(@"获取验证码") forState:UIControlStateNormal];
    [verifyCodeButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [registerButton setTitle:text(@"登录") forState:UIControlStateNormal];
    [registerButton cornerRadiusStyle];
    registerButton.backgroundColor = MAIN_COLOR;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verifyCodeButtonClicked:(id)sender {
    
    if (![phoneNumberText.text isValidatePhoneNumber]) {
        
        [MBProgressHUD showError:text(@"手机号格式不正确")];
    }
    else {
        
        verifyCodeButton.enabled = NO;
        
        _seconds = 60;
        
        [MBProgressHUD showMessage:text(@"获取验证码中")];
        
        LoginAPI *loginAPI = [LoginAPI new];
        @weakify(self)
        [loginAPI setSuccessBlock:^(id result) {
            
            @strongify(self)
            
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
            
            [MBProgressHUD showSuccess:text(@"获取成功，验证码将发至您的手机")];
            
            [self->verifyCodeText becomeFirstResponder];
        }];
        [loginAPI sendVerifyCode:[phoneNumberText.text trim]];
    }
}

- (IBAction)registerButtonClicked:(id)sender {
    
    if (![phoneNumberText.text isValidatePhoneNumber]) {
        
        [MBProgressHUD showError:text(@"手机号格式不正确")];
    }
    else if ([verifyCodeText.text trim].length != 6) {
        
        [MBProgressHUD showError:text(@"验证码为六位数字")];
    }
    else {
        
        [MBProgressHUD showMessage:text(@"登录中")];
        
        [LoginAPI sharedInstance].delegate = self;
        [[LoginAPI sharedInstance] loginWithPhoneNumber:[phoneNumberText.text trim] verifyCode:[verifyCodeText.text trim]];
    }
}

- (void)timerTick:(NSTimer *)timer {
    
    if (_seconds == 0) {
        
        [timer invalidate];
        verifyCodeButton.enabled = YES;
        [verifyCodeButton setTitle:text(@"获取验证码") forState:UIControlStateNormal];
    }
    else {
        
        _seconds --;
        [verifyCodeButton setTitle:[NSString stringWithFormat:@"%li%@", (long)_seconds, text(@"秒")] forState:UIControlStateNormal];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    
    [phoneNumberText resignFirstResponder];
    [verifyCodeText resignFirstResponder];
}

#pragma mark - NavigationBarWidgetDelegate methods

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == phoneNumberText) {
        
        [phoneNumberText resignFirstResponder];
        [self verifyCodeButtonClicked:nil];
    }
    else if (textField == verifyCodeText) {
        
        [verifyCodeText resignFirstResponder];
    }
    return YES;
}

#pragma mark - LoginDelegate methods

- (void)didFinishLogin:(LoginAPI *)loginAPI {
    
    [MBProgressHUD showSuccess:text(@"登录成功")];
    
    SET_PHONENUMBER([phoneNumberText.text trim]);
    
    if (_delegate && [_delegate respondsToSelector:@selector(registerView:didFinishRegister:)])
        [_delegate registerView:self didFinishRegister:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFailedLogin:(LoginAPI *)loginAPI {
    
    
}

@end
