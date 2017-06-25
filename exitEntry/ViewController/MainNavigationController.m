//
//  MainNavigationController.m
//  copybook
//
//  Created by 尹楠 on 15/12/5.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "MainNavigationController.h"
#import "MainTabBarController.h"

@interface MainNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationBar.hidden = YES;

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.interactivePopGestureRecognizer setDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    [super pushViewController:viewController animated:animated];

    [((MainTabBarController *) viewController.tabBarController) hideNewTabBar];
}

@end
