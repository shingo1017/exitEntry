//
//  NavigationBarWidget.h
//  copybook
//
//  Created by 尹楠 on 15/1/20.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarWidgetDelegate;

@interface NavigationBarWidget : UIView {

    UIView *backgroundView;
    UILabel *titleLabel;
    UIButton *backButton;
}

@property(nonatomic, weak) id <NavigationBarWidgetDelegate> delegate;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, assign) BOOL backButtonHidden;
@property(nonatomic, strong) UIButton *rightBarButton;

- (void)showNavigationBar;

- (void)hideNavigationBar;

- (void)addRightBarButtonWithTitle:(NSString *)title;

- (void)addRightBarButtonWithImage:(UIImage *)image;
@end

@protocol NavigationBarWidgetDelegate <NSObject>

@optional

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget;

- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget;

- (BOOL)shouldPopViewController:(NavigationBarWidget *)navigationBarWidget;

@end
