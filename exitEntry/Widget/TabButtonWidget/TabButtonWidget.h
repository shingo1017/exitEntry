//
//  TabButtonWidget.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/30.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabButtonWidgetDelegate;

@interface TabButtonWidget : UIView {
    
    UIImageView *imageView;
    UILabel *titleLabel;
    UIButton *button;
}

@property (nonatomic, weak) id<TabButtonWidgetDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *imageNameStateNormal;
@property (nonatomic, copy) NSString *imageNameStateSelected;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColorStateNormal;
@property (nonatomic, strong) UIColor *titleColorStateSelected;
@property (nonatomic, assign) BOOL selected;

- (void)setupViewsWithWidth:(CGFloat)width;

@end

@protocol TabButtonWidgetDelegate <NSObject>

- (void)didClickedTabButtonWidget:(TabButtonWidget *)tabButtonWidget;

@end
