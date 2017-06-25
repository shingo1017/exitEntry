//
//  NeedLoginView.h
//  copybook
//
//  Created by 尹楠 on 16/10/31.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginView.h"
#import "RegisterView.h"

@interface NeedLoginView : BaseViewController <LoginViewDelegate, RegisterViewDelegate> {
    
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *cancelButton;
}

@end
