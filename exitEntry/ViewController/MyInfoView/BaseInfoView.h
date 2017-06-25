//
//  BaseInfoView.h
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"
#import "PickerWidget.h"
#import "DatePickerWidget.h"

@interface BaseInfoView : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NavigationBarWidgetDelegate, PickerWidgetDelegate, DatePickerWidgetDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *infoTableView;
    IBOutlet PickerWidget *countryPickerView;
    IBOutlet PickerWidget *identityTypePickerView;
    IBOutlet DatePickerWidget *identityExpireDatePickerView;
//    IBOutlet PickerWidget *personTypePickerView;
//    IBOutlet PickerWidget *personAreaTypePickerView;
//    IBOutlet PickerWidget *genderPickerView;
//    IBOutlet DatePickerWidget *birthdayPickerView;
    IBOutlet PickerWidget *occupationPickerView;
}

@end
