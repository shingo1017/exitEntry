//
//  DatePickerWidget.m
//  copybook
//
//  Created by 尹楠 on 17/1/3.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "DatePickerWidget.h"

@implementation DatePickerWidget

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = MODEL_BACKGROUND_COLOR;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - 260);
    [dismissButton addTarget:self action:@selector(toolBarDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];
    
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, dismissButton.height, SCREEN_WIDTH, 44)];
    toolbarView.backgroundColor = BACKGROUND_COLOR;
    [toolbarView lineDockTopWithColor:BORDER_COLOR];
    [self addSubview:toolbarView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 60, 44);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [cancelButton setTitle:text(@"取消") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(toolBarCanelClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbarView addSubview:cancelButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44);
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [doneButton setTitle:text(@"完成") forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(toolBarDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbarView addSubview:doneButton];
    
    _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, toolbarView.bottom, SCREEN_WIDTH, 216)];
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    _datePickerView.backgroundColor = BACKGROUND_COLOR;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _datePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:appDelegate.language];
    [self addSubview:_datePickerView];
}

- (void)toolBarCanelClick {
    
    [self hide];
}

- (IBAction)datePickerViewValueChanged:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerWidget:dateChanged:)])
        [_delegate datePickerWidget:self dateChanged:_datePickerView.date];
}

- (void)toolBarDoneClick {
    
    [self hide];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickedDateDoneButton:)])
        [_delegate didClickedDateDoneButton:self];
}

- (void)show {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 1.0f;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.0f;
    }];
}

@end
