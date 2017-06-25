//
//  MyView.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NavigationBarWidget.h"
#import "PickerWidget.h"

@interface MyView : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PickerWidgetDelegate> {
    
//    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIView *myHeaderView;
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *nicknameLabel;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *myFooterView;
    IBOutlet UIButton *logoutButton;
    IBOutlet PickerWidget *languagePickerWidget;
}


@end

