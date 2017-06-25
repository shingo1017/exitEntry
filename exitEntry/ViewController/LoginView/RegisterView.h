//
//  RegisterView.h
//  copybook
//
//  Created by 尹楠 on 16/1/11.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@protocol RegisterViewDelegate;

@interface RegisterView : BaseViewController <UITextFieldDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIView *phoneNumberContainerView;
    IBOutlet UILabel *phoneNumberCaption;
    IBOutlet UITextField *phoneNumberText;
    IBOutlet UIView *verifyCodeContainerView;
    IBOutlet UILabel *verifyCodeCaption;
    IBOutlet UITextField *verifyCodeText;
    IBOutlet UIButton *verifyCodeButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *loginButton;
}

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

@end

@protocol RegisterViewDelegate <NSObject>;

- (void)registerView:(RegisterView *)registerView didFinishRegister:(BOOL)success;

@end
