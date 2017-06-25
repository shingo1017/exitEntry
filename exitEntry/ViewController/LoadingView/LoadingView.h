//
//  LoadingView.h
//  copybook
//
//  Created by 尹楠 on 15/3/3.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
    
    IBOutlet UIView *noNetworkContainerView;
    IBOutlet UIButton *retryButton;
    IBOutlet UIImageView * imageView;
    NSMutableArray *animationImages;//图片数组
}

- (void)addRetryButtonHandler:(id)handler action:(SEL)action;
- (void)checkNetwork;
- (void)showNoNetwork;
- (void)startLoadingAnimation;//开始动画
- (void)stopLoadingAnimation;

+ (LoadingView *)showLoadingInView:(UIView *)view;

@end
