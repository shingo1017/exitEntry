//
//  PickerWidget.h
//  copybook
//
//  Created by 尹楠 on 17/1/3.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerWidget;

@protocol PickerWidgetDelegate <NSObject>

- (void)didClickedDoneButton:(PickerWidget *)pickerWidget;

@end

@interface PickerWidget : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet id<PickerWidgetDelegate> delegate;

- (void)show;
- (void)hide;

@end
