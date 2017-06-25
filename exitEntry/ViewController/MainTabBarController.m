//
//  MainTabBarController.m
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "MainTabBarController.h"
#import "LanguagePickerView.h"
#import "RegisterView.h"
#import "UserAPI.h"
#import "LoginAPI.h"
#import "BookAPI.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    ((AppDelegate *) [UIApplication sharedApplication].delegate).mainNavigationController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldShowLoginNotification:) name:K_SHOULD_SHOW_LOGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewTabBar) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLanguageNotification:) name:K_DID_CHANGE_LANGUAGE_NOTIFICATION object:nil];
    
    self.tabBar.hidden = YES;
    tabBarView.backgroundColor = BACKGROUND_COLOR;
    tabBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [tabBarView lineDockTopWithColor:BORDER_COLOR];
    [self.view addSubview:tabBarView];
    
//    CGFloat width = SCREEN_WIDTH / 4;
    
    homeButton = [[TabButtonWidget alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, tabBarView.height)];
    homeButton.title = text(@"首页");
    homeButton.titleColorStateNormal = PLACEHOLDER_COLOR;
    homeButton.titleColorStateSelected = MAIN2_COLOR;
    homeButton.imageNameStateNormal = @"首页_普通";
    homeButton.imageNameStateSelected = @"首页_选中";
    homeButton.delegate = self;
    homeButton.index = 1;
    [homeButton setupViewsWithWidth:SCREEN_WIDTH / 3];
    [tabBarView addSubview:homeButton];
    homeButton.selected = YES;
    
    messageButton = [[TabButtonWidget alloc] initWithFrame:CGRectMake(homeButton.right, 0, SCREEN_WIDTH / 3, tabBarView.height)];
    messageButton.title = text(@"消息");
    messageButton.titleColorStateNormal = PLACEHOLDER_COLOR;
    messageButton.titleColorStateSelected = MAIN2_COLOR;
    messageButton.imageNameStateNormal = @"消息_普通";
    messageButton.imageNameStateSelected = @"消息_选中";
    messageButton.delegate = self;
    messageButton.index = 2;
    [messageButton setupViewsWithWidth:SCREEN_WIDTH / 3];
    [tabBarView addSubview:messageButton];
    
    myButton = [[TabButtonWidget alloc] initWithFrame:CGRectMake(messageButton.right, 0, SCREEN_WIDTH / 3, tabBarView.height)];
    myButton.title = text(@"我的");
    myButton.titleColorStateNormal = PLACEHOLDER_COLOR;
    myButton.titleColorStateSelected = MAIN2_COLOR;
    myButton.imageNameStateNormal = @"我的_普通";
    myButton.imageNameStateSelected = @"我的_选中";
    myButton.delegate = self;
    myButton.index = 4;
    [myButton setupViewsWithWidth:SCREEN_WIDTH / 3];
    [tabBarView addSubview:myButton];
    
//    courseButton.left = 0.0f;
//    courseButton.width = width;
//    categoryButton.left = courseButton.right;
//    categoryButton.width = width;
//    contentButton.left = categoryButton.right;
//    contentButton.width = width;
//    myButton.left = contentButton.right;
//    myButton.width = width;
    
    [self initConfigs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNewTabBar {
    
    tabBarView.frame = CGRectMake(0.0f, self.view.bounds.size.height + 15.0f, SCREEN_WIDTH, TAB_BAR_HEIGHT);
}

- (void)showNewTabBar {
    
    tabBarView.frame = CGRectMake(0.0f, self.view.bounds.size.height - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
}

- (void)didClickedTabButtonWidget:(TabButtonWidget *)tabButtonWidget {
    
    homeButton.selected = NO;
    messageButton.selected = NO;
    myButton.selected = NO;
    
    tabButtonWidget.selected = YES;
    
    self.selectedIndex = tabButtonWidget.index - 1;
}

- (void)selectTabBarIndex:(int)index {
    
    UIButton *button = (UIButton *)[tabBarView viewWithTag:index + 1];
    [self tabButtonClicked:button];
}

- (void)shouldShowLoginNotification:(NSNotification *)notification {
    
    RegisterView *registerView = [UIStoryboard viewControllerWithName:@"RegisterView"];
    [self presentViewController:registerView animated:YES completion:nil];
}

- (void)didChangeLanguageNotification:(NSNotification *)notification {
    
    homeButton.title = text(@"首页");
    messageButton.title = text(@"消息");
    myButton.title = text(@"我的");
    
    [Dictionary setGenderArray:nil];
    
    [self initConfigs];
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

@end
