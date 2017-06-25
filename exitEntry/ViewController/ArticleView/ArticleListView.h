//
//  ArticleListView.h
//  exitEntry
//
//  Created by 尹楠 on 17/4/6.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@interface ArticleListView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITableView *articleTableView;
}

@property (nonatomic, assign) NSInteger columnId;

@end
