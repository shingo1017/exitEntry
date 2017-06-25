//
//  SectionHeaderWidget.m
//  novel
//
//  Created by wangyanan on 14/12/6.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import "SectionHeaderWidget.h"

@implementation SectionHeaderWidget

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.height = 50.0f;
    
    _lineView.backgroundColor = MAIN_COLOR;
    [_lineView cornerRadiusStyleWithValue:1.0f];
    titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = TITLE_COLOR;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:kFontSizeFootnote];
    [rightButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    rightButton.height = self.height;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    titleLabel.text = _title;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    
    _rightButtonTitle = rightButtonTitle;
    
    [rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
}

- (void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor {
    
    _rightButtonTitleColor = rightButtonTitleColor;
    
    [rightButton setTitleColor:_rightButtonTitleColor forState:UIControlStateNormal];
}

- (void)setRightButtonEnabled:(BOOL)rightButtonEnabled {
    
    _rightButtonEnabled = rightButtonEnabled;
    
    rightButton.hidden = !_rightButtonEnabled;
}

- (void)addRightButtonClickedHandler:(id)handler action:(SEL)action {
    
    [rightButton addTarget:handler action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
