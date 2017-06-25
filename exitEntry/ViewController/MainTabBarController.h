//
//  MainTabBarController.h
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabButtonWidget.h"

@interface MainTabBarController : UITabBarController <TabButtonWidgetDelegate> {
    
    IBOutlet UIView *tabBarView;
    
    IBOutlet TabButtonWidget *homeButton;
    IBOutlet TabButtonWidget *messageButton;
//    IBOutlet TabButtonWidget *entertainmentButton;
    IBOutlet TabButtonWidget *myButton;
}

- (void)hideNewTabBar;
- (void)showNewTabBar;
- (void)selectTabBarIndex:(int)index;

- (IBAction)tabButtonClicked:(id)sender;

@end
