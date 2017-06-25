//
//  AppDelegate.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *language;
@property (nonatomic, weak) UINavigationController *mainNavigationController;
@property (nonatomic, weak) MainTabBarController *mainTabBarController;

- (NSString *)showText:(NSString *)key;

@end

