//
//  StayInfoView.h
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"
#import "PickerWidget.h"
#import "DatePickerWidget.h"

@interface StayInfoView : BaseViewController <UITableViewDataSource, UITableViewDelegate, NavigationBarWidgetDelegate, PickerWidgetDelegate, DatePickerWidgetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *infoTableView;
//    IBOutlet DatePickerWidget *checkInDatePickerView;
    IBOutlet DatePickerWidget *checkOutPickerView;
//    IBOutlet PickerWidget *policeStationPickerView;
//    IBOutlet PickerWidget *communityPickerView;
    IBOutlet PickerWidget *houseTypePickerView;
    IBOutlet PickerWidget *landlordCountryPickerView;
    IBOutlet PickerWidget *landlordGenderPickerView;
}

@end
