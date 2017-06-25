//
//  DatePickerWidget.h
//  copybook
//
//  Created by 尹楠 on 17/1/3.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerWidget;

@protocol DatePickerWidgetDelegate <NSObject>

- (void)didClickedDateDoneButton:(DatePickerWidget *)datePickerWidget;

@optional

- (void)datePickerWidget:(DatePickerWidget *)datePickerWidget dateChanged:(NSDate *)date;

@end

@interface DatePickerWidget : UIView

@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic, weak) IBOutlet id<DatePickerWidgetDelegate> delegate;

- (void)show;
- (void)hide;

@end
