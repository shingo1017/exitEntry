//
//  ResetPasswordView.h
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@interface ResetPasswordView : BaseViewController <UITextFieldDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIView *userNameContainerView;
    IBOutlet UITextField *userNameText;
    IBOutlet UIView *verifyCodeContainerView;
    IBOutlet UITextField *verifyCodeText;
    IBOutlet UIButton *verifyCodeButton;
    IBOutlet UIView *passwordContainerView;
    IBOutlet UITextField *passwordText;
    IBOutlet UIButton *resetButton;
}

@property (nonatomic, strong) NSString *userName;

@end
