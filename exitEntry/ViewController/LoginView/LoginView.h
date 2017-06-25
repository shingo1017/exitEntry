//
//  LoginView.h
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@protocol LoginViewDelegate;

@interface LoginView : BaseViewController <UITextFieldDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIView *phoneNumberContainerView;
    IBOutlet UILabel *phoneNumberCaption;
    IBOutlet UITextField *phoneNumberText;
    IBOutlet UIView *passwordContainerView;
    IBOutlet UILabel *passwordCaption;
    IBOutlet UITextField *passwordText;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgetButton;
}

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end

@protocol LoginViewDelegate <NSObject>;

- (void)loginView:(LoginView *)loginView didFinishLogin:(BOOL)success;

@end
