//
//  NeedLoginView.m
//  copybook
//
//  Created by 尹楠 on 16/10/31.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "NeedLoginView.h"
#import "MainNavigationController.h"
#import "LoginAPI.h"

@interface NeedLoginView () {
    
    UINavigationController *_loginNavigationContoller;
    LoginView *_loginView;
    RegisterView *_registerView;
}

@end

@implementation NeedLoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [registerButton cornerRadiusStyle];
    registerButton.backgroundColor = MAIN_COLOR;
    [registerButton setTitle:text(@"注册") forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton cornerRadiusStyle];
    [loginButton borderStyle];
    [loginButton setTitle:text(@"登录") forState:UIControlStateNormal];
    [loginButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [cancelButton setTitle:text(@"稍后注册") forState:UIControlStateNormal];
    [cancelButton setTitleColor:SUMMARY_COLOR forState:UIControlStateNormal];
    
    _registerView = [UIStoryboard viewControllerWithName:@"RegisterView"];
    _registerView.delegate = self;
    
    _loginView = [UIStoryboard viewControllerWithName:@"LoginView"];
    _loginView.delegate = self;
    _loginNavigationContoller = [[MainNavigationController alloc] initWithRootViewController:_loginView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(id)sender {

    [self presentViewController:_loginNavigationContoller animated:YES completion:nil];
}

- (IBAction)registerButtonClicked:(id)sender {
    
    [self presentViewController:_registerView animated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishLogin {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"deviceRegistered"] == NO && [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
        
        //the device did not register.
        //banding device for push notification.
        LoginAPI *loginAPI = [LoginAPI new];
        @weakify(self)
        [loginAPI setSuccessBlock:^(id result) {
            
            @strongify(self)
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deviceRegistered"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [loginAPI registerDevice];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LoginViewDelegate

- (void)loginView:(LoginView *)loginView didFinishLogin:(BOOL)success {
    
    [_loginNavigationContoller dismissViewControllerAnimated:NO completion:nil];
    
    [self finishLogin];
}

#pragma mark - RegisterViewDelegate

- (void)registerView:(RegisterView *)registerView didFinishRegister:(BOOL)success {
    
    [_registerView dismissViewControllerAnimated:NO completion:nil];
    
    [self finishLogin];
}

- (void)transformToLogin:(RegisterView *)registerView {
    
    [_registerView dismissViewControllerAnimated:NO completion:^{
        
        [self presentViewController:_loginNavigationContoller animated:YES completion:nil];
    }];
}

@end
