
//
//  LoginView.m
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import "LoginView.h"
#import "RegisterView.h"
#import "ResetPasswordView.h"
#import "LoginAPI.h"

@interface LoginView ()

@end

@implementation LoginView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    navigationBarWidget.title = text(@"登录");
    navigationBarWidget.delegate = self;
    [phoneNumberContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    phoneNumberCaption.text = text(@"手机号");
    phoneNumberText.textColor = TITLE_COLOR;
    phoneNumberText.placeholder = text(@"请输入手机号");
    [passwordContainerView lineDockBottomWithColor:BACKGROUND_COLOR];
    passwordCaption.text = text(@"密码");
    passwordText.textColor = TITLE_COLOR;
    passwordText.placeholder = text(@"请输入密码");
    [loginButton cornerRadiusStyle];
    loginButton.backgroundColor = MAIN_COLOR;
    [forgetButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    phoneNumberText.text = PHONENUMBER;
    passwordText.text = PASSWORD;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPasswordButtonClicked:(id)sender {
    
    ResetPasswordView *resetPasswordView = [UIStoryboard viewControllerWithName:@"ResetPasswordView"];
    resetPasswordView.userName = [phoneNumberText.text trim];
    [self.navigationController pushViewController:resetPasswordView animated:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    
    if ([phoneNumberText.text trim].length == 0) {
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@%@", text(@"手机号"), text(@"不能为空")]];
    }
    else if ([passwordText.text trim].length < 6) {
        
        NSString *errorMessage = [NSString stringWithFormat:@"%@%@", text(@"密码"), text(@"长度不能少于N位")];
        [MBProgressHUD showError:[NSString stringWithFormat:errorMessage, @"6"]];
    }
    else {
        
        [MBProgressHUD showMessage:text(@"登录中")];
        
        LoginAPI *loginAPI = [LoginAPI new];
        @weakify(self);
        [loginAPI setSuccessBlock:^(id result) {
            
            @strongify(self)
            
            User *user = [[User alloc] initWithDictionary:result error:nil];
            [User setDefaultUser:user];
            
            SET_PHONENUMBER([self->phoneNumberText.text trim]);
            SET_PASSWORD([self->passwordText.text trim]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_DID_LOGIN_NOTIFICATION object:nil];
          
            [self finishLogin];
        }];
        [loginAPI login:[phoneNumberText.text trim] password:[passwordText.text trim]];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    
    [self dismissKeyboard];
}

- (void)finishLogin {
    
    [self dismissKeyboard];
    
    [MBProgressHUD hideHUDs];
    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@%@", text(@"登录"), text(@"成功")]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didFinishLogin:)])
        [_delegate loginView:self didFinishLogin:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboard {
    
    [phoneNumberText resignFirstResponder];
    [passwordText resignFirstResponder];
}

#pragma mark - NavigationBarWidgetDelegate methods

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == phoneNumberText)
    {
        [phoneNumberText resignFirstResponder];
        [passwordText becomeFirstResponder];
    }
    return YES;
}

@end
