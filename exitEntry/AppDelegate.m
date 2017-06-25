//
//  AppDelegate.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginAPI.h"
#import "BookAPI.h"
#import "UserAPI.h"
#import "Dictionary.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initJPushWithOptions:launchOptions];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"language"])
        self.language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    
    return YES;
}

- (NSString *)showText:(NSString *)key {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:_language ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
}

- (void)initJPushWithOptions:(NSDictionary *)launchOptions {
    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"9d4bd539def624ce93e92fc4"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
}

- (void)initConfigs {
    
    CommonAPI *commonAPI = [CommonAPI new];
    [commonAPI setSuccessBlock:^(id result) {
        
        [Dictionary setCountryArray:[Dictionary dictionariesWithDictionary:result[@"country"]]];
        [Dictionary setIdentityTypeArray:[Dictionary dictionariesWithDictionary:result[@"credential_type"]]];
        [Dictionary setPersonTypeArray:[Dictionary dictionariesWithDictionary:result[@"person_type"]]];
        [Dictionary setPersonAreaTypeArray:[Dictionary dictionariesWithDictionary:result[@"person_area_type"]]];
        [Dictionary setOccupationArray:[Dictionary dictionariesWithDictionary:result[@"occupation"]]];
        [Dictionary setVisaTypeArray:[Dictionary dictionariesWithDictionary:result[@"visa_type"]]];
        [Dictionary setEntryPortArray:[Dictionary dictionariesWithDictionary:result[@"entry_port"]]];
        [Dictionary setStayReasonArray:[Dictionary dictionariesWithDictionary:result[@"stay_reason"]]];
        [Dictionary setPoliceStationArray:[Dictionary dictionariesWithDictionary:result[@"police_station"]]];
        [Dictionary setCommunityDictionary:result[@"community"]];
        [Dictionary setHouseTypeArray:[Dictionary dictionariesWithDictionary:result[@"house_type"]]];
    }];
    [commonAPI getConfigs];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (deviceTokenString.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([BookInfo defaultBookInfo].phoneNumber && ![[NSUserDefaults standardUserDefaults] objectForKey:@"aliased"]) {
        
        [JPUSHService setAlias:[BookInfo defaultBookInfo].phoneNumber callbackSelector:nil object:nil];
            
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aliased"];
    }
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
                      
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
        
        [self initJPushWithOptions:nil];
    }
    
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([Dictionary countryArray].count == 0) {
        
        [self initConfigs];
    }
    
    if (![User isLogin])
        [[LoginAPI sharedInstance] autoLogin];
    else
        [[LoginAPI sharedInstance] refreshBookStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
