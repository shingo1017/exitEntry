//
//  VisaInfoView.h
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"
#import "PickerWidget.h"
#import "DatePickerWidget.h"

@interface VisaInfoView : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NavigationBarWidgetDelegate, PickerWidgetDelegate, DatePickerWidgetDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *infoTableView;
    IBOutlet PickerWidget *visaTypePickerView;
    IBOutlet DatePickerWidget *visaExpireDatePickerView;
//    IBOutlet DatePickerWidget *enterDatePickerView;
//    IBOutlet PickerWidget *entryPortPickerView;
    IBOutlet PickerWidget *stayReasonPickerView;
//    IBOutlet DatePickerWidget *stayExpireDatePickerView;
}

@end
