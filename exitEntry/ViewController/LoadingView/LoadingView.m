//
//  LoadingView.m
//  copybook
//
//  Created by 尹楠 on 15/3/3.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+ (LoadingView *)showLoadingInView:(UIView *)view {

    LoadingView *loadingView = (LoadingView *)[UIView viewWithName:@"LoadingView"];
    loadingView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    [view addSubview:loadingView];
    
    if (NETWORK)
        [loadingView startLoadingAnimation];
    else
        [loadingView showNoNetwork];
    
    return loadingView;
}

- (void)removeFromSuperview {
    
    [self stopLoadingAnimation];
    
    [super removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self addloadView];
    }
    return self;
}

- (void)awakeFromNib {
    
//    [self addloadView];
}

- (void)addloadView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    imageView.image = [UIImage imageNamed:@"Mars0001"];

    animationImages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 56;i++) {
        NSString *fileName = [NSString stringWithFormat:@"Mars000%i",i];
        [animationImages addObject:[UIImage imageNamed:fileName]];
    }
    
    [retryButton borderStyleWithColor:[UIColor whiteColor]];
    [retryButton roundHeightStyle];
}

- (void)addRetryButtonHandler:(id)handler action:(SEL)action {
    
    [retryButton addTarget:handler action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkNetwork {
    
    if (!NETWORK)
        [self showNoNetwork];
}

- (void)showNoNetwork {
    
    self.hidden = NO;
    noNetworkContainerView.hidden = NO;
}

- (void)startLoadingAnimation {
    
    self.hidden = NO;
    noNetworkContainerView.hidden = YES;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float imageViewWidth = floatByScale(50);
    float imageViewHeight = floatByScale(50);
    
    imageView.frame = CGRectMake((width-imageViewWidth)/2, (height-imageViewHeight)/2, imageViewWidth, imageViewHeight);
    
    imageView.animationImages = animationImages;
    imageView.animationDuration = 1.0f;//设置动画时间0.053f
    imageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [imageView startAnimating];//开始播放动画
}

- (void)stopLoadingAnimation {
    
    if (imageView.isAnimating) {
        [imageView stopAnimating];
    }
    imageView.image = [UIImage imageNamed:@"Mars0001"];
}

@end
