//
//  NavigationBarWidget.m
//  copybook
//
//  Created by 尹楠 on 15/1/20.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import "NavigationBarWidget.h"

@implementation NavigationBarWidget

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self loadViews];
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];

    [self loadViews];
}

- (void)loadViews {

    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    //    imageView.image = [UIImage imageNamed:@"导航栏背景图"];
    //    [self insertSubview:imageView atIndex:0];

    self.height = NAVIGATIONBAR_HEIGHT;

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT, floatByScale(48.0f), NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];

    self.backgroundColor = MAIN_COLOR;
    [backButton setImage:[UIImage imageNamed:@"ic_return"] forState:UIControlStateNormal];

    //[self lineDockBottomWithColor:WHITE_COLOR];
}


#pragma mark - Button Events

- (void)backButtonClicked:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(didClickedBackButton:)]) {
        [_delegate didClickedBackButton:self];
    } else if (_delegate && [_delegate respondsToSelector:@selector(shouldPopViewController:)]) {

        if ([_delegate shouldPopViewController:self])
            [MAIN_NAVIGATIONCONTROLLER popViewControllerAnimated:YES];
    } else
        [MAIN_NAVIGATIONCONTROLLER popViewControllerAnimated:YES];
}

- (void)rightBarButtonClicked:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(didClickedRightBarButton:)]) {
        [_delegate didClickedRightBarButton:self];
    }
}


#pragma mark - Right Bar Button


- (void)addRightBarButtonWithTitle:(NSString *)title {
    if (nil == self.rightBarButton) {

        self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBarButton setFrame:CGRectMake(SCREEN_WIDTH - 50.0f, STATUS_BAR_HEIGHT, 50.0f, NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT)];
        [self.rightBarButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];

        [self.rightBarButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (nil == self.rightBarButton.superview) {
            [self addSubview:self.rightBarButton];
        }
    }
    [self.rightBarButton setTitle:(nil == title) ? @"" : title forState:UIControlStateNormal];
    [self.rightBarButton sizeToFit];
    self.rightBarButton.left = SCREEN_WIDTH - self.rightBarButton.width - 10;
    self.rightBarButton.height = NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT;
}

- (void)addRightBarButtonWithImage:(UIImage *)image {
    if (nil == self.rightBarButton) {

        self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBarButton setFrame:CGRectMake(SCREEN_WIDTH - 50.0f, STATUS_BAR_HEIGHT, 50.0f, NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT)];
        [self.rightBarButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];

        [self.rightBarButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (nil == self.rightBarButton.superview) {
            [self addSubview:self.rightBarButton];
        }
    }
//    [self.rightBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.rightBarButton setImage:image forState:UIControlStateNormal];
    [self.rightBarButton setContentMode:UIViewContentModeScaleAspectFill];

//    [self.rightBarButton setTitle:(nil == title) ? @"" : title forState:UIControlStateNormal];

}


#pragma mark - Set Methods

- (void)setTitle:(NSString *)title {

    _title = title;

    if (_title.length > 0) {

        if (!titleLabel) {

            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(floatByScale(40), STATUS_BAR_HEIGHT, SCREEN_WIDTH - floatByScale(80), NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT)];
            titleLabel.font = [UIFont systemFontOfSize:16];

            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self insertSubview:titleLabel atIndex:1];

            titleLabel.textColor = [UIColor whiteColor];
        }
        titleLabel.text = _title;
    } else
        titleLabel.text = @"";
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden {

    _backButtonHidden = backButtonHidden;

    backButton.hidden = _backButtonHidden;
}


#pragma mark - Show/Hide

- (void)showNavigationBar {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.top = 0;
    [UIView commitAnimations];
}

- (void)hideNavigationBar {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.top = 0 - self.height;
    [UIView commitAnimations];
}


@end
