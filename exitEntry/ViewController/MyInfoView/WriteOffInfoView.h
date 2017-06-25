//
//  WriteOffInfoView.h
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"
#import "PickerWidget.h"
#import "DatePickerWidget.h"

@interface WriteOffInfoView : BaseViewController <UITableViewDataSource, UITableViewDelegate, NavigationBarWidgetDelegate, PickerWidgetDelegate, DatePickerWidgetDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *infoTableView;
    IBOutlet DatePickerWidget *leaveCountryPickerView;
}

@end
