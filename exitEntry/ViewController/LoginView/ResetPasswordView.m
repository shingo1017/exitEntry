
//
//  ResetPasswordView.m
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import "ResetPasswordView.h"
#import "LoginAPI.h"

@interface ResetPasswordView () {
    
    NSString *_validateCode;
    NSString *_validateId;
    NSInteger _seconds;
}

@end

@implementation ResetPasswordView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;

    navigationBarWidget.title = text(@"重置密码");
    navigationBarWidget.delegate = self;
    
    [userNameContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    userNameText.textColor = TITLE_COLOR;
    [verifyCodeContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    verifyCodeText.textColor = TITLE_COLOR;
    [verifyCodeButton setTitleColor:SUMMARY_COLOR forState:UIControlStateNormal];
    [passwordContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    passwordText.textColor = TITLE_COLOR;
    [resetButton cornerRadiusStyle];
    resetButton.backgroundColor = MAIN_COLOR;
    
    userNameText.text = _userName;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verifyCodeButtonClicked:(id)sender {
    
    if (![userNameText.text isValidatePhoneNumber]) {
        
        [MBProgressHUD showError:text(@"手机号格式不正确")];
    }
    else {
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        _seconds = 60;
        verifyCodeButton.enabled = NO;
        
        [MBProgressHUD showMessage:text(@"获取验证码中")];
        
        LoginAPI *loginAPI = [LoginAPI new];
        @weakify(self);
        [loginAPI setSuccessBlock:^(id result) {
            
            @strongify(self);
            
            [MBProgressHUD showSuccess:text(@"获取成功，验证码将发至您的手机")];
            
            _validateCode = result[@"verify_code"];
            
            [self->verifyCodeText becomeFirstResponder];
        }];
        [loginAPI sendVerifyCode:[userNameText.text trim] action:@"password_reset"];
    }
}

- (IBAction)resetButtonClicked:(id)sender {
    
    if (![userNameText.text isValidatePhoneNumber]) {
        
        [MBProgressHUD showError:text(@"手机号格式不正确")];
    }
    else if ([verifyCodeText.text trim].length != 6) {
        
        [MBProgressHUD showError:text(@"验证码为六位数字")];
    }
    else if (![verifyCodeText.text isEqualToString:_validateCode]) {
        
        [MBProgressHUD showError:text(@"验证码错误")];
    }
    else if ([passwordText.text trim].length < 6) {
        
        NSString *errorMessage = [NSString stringWithFormat:@"%@%@", text(@"密码"), text(@"长度不能少于N位")];
        [MBProgressHUD showError:[NSString stringWithFormat:errorMessage, @"6"]];
    }
    else {
        
        [MBProgressHUD showMessage:text(@"重置密码中")];
        
        LoginAPI *loginAPI = [LoginAPI new];
        
        @weakify(self);
        [loginAPI setSuccessBlock:^(id result) {
            
            @strongify(self);
            
            [self dismissKeyboard];
            
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@%@", text(@"重置密码"), text(@"成功")]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [loginAPI resetPassword:[userNameText.text trim] password:[passwordText.text trim] verifyCode:[verifyCodeText.text trim]];
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
    
    [userNameText resignFirstResponder];
    [verifyCodeText resignFirstResponder];
    [passwordText resignFirstResponder];
}

#pragma mark - NavigationBarWidgetDelegate methods

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == userNameText) {
        
        [userNameText resignFirstResponder];
        [self verifyCodeButtonClicked:nil];
    }
    else if (textField == verifyCodeText) {
        
        [verifyCodeText resignFirstResponder];
        [passwordText becomeFirstResponder];
    }
    return YES;
}

@end
