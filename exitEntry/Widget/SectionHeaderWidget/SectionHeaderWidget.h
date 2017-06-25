//
//  SectionHeaderWidget.h
//  novel
//
//  Created by wangyanan on 14/12/6.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderWidget : UIView {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *rightButton;
}

@property (nonatomic, retain) IBOutlet UIView *lineView;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *rightButtonTitle;
@property (nonatomic, assign) BOOL rightButtonEnabled;
@property (nonatomic, retain) UIColor *rightButtonTitleColor;

- (void)addRightButtonClickedHandler:(id)handler action:(SEL)action;

@end
