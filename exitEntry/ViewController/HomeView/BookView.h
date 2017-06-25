//
//  BookView.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/28.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@interface BookView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *bookTableView;
    IBOutlet UIView *headerView;
    IBOutlet UILabel *rejectReasonLabel;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *submitButton;
}

@end
