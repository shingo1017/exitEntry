//
//  FeedbackView.m
//  copybook
//
//  Created by 尹楠 on 16/11/23.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "FeedbackView.h"
#import "MessageAPI.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface FeedbackView () {
    
    BOOL _wasKeyboardManagerEnabled;
}

@end

@implementation FeedbackView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navigationBarWidget.title = self.title;
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"发送")];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [contentText becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [self sendButtonClicked:nil];
//    return YES;
//}

- (void)keyboardWillChangeFrameNotify:(NSNotification *)notify {
    
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        contentText.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + transformY - self.inputView.height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget {
    
    MessageAPI *messageAPI = [MessageAPI new];
    @weakify(self)
    [messageAPI setSuccessBlock:^(id result) {
        
        @strongify(self)
        [MBProgressHUD showSuccess:text(@"发送成功")];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [messageAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
        
        [MBProgressHUD showError:text(@"发送失败")];
    }];
    [messageAPI leaveMessage:[contentText.text trim]];
}

@end
