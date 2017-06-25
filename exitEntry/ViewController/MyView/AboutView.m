//
//  AboutView.m
//  Entlphone
//
//  Created by 尹楠 on 15/4/1.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()

@end

@implementation AboutView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;

    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    imageView.image = [UIImage imageNamed:icon];
    
    line.height = 0.5f;
    [versionLabel roundHeightStyle];
    
    navigationBarWidget.title = text(@"关于我们");
    
    //获取应用名称，版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"%@ v%@版 for iOS", [infoDictionary objectForKey:@"CFBundleDisplayName"],version];
    
    companyName1.text = text(@"版权所有公司名称");
}

@end
