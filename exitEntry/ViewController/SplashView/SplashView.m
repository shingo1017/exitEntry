//
//  SplashView.m
//  novel
//
//  Created by 尹楠 on 16/2/16.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import "SplashView.h"
#import "LanguagePickerView.h"
#import "MainTabBarController.h"
#import "BookAPI.h"
#import "UserAPI.h"
#import "JPUSHService.h"

@interface SplashView ()
@end

@implementation SplashView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//    iconImageView.image = [UIImage imageNamed:icon];
}

- (void)viewDidAppear:(BOOL)animated {
    
    //检查自动更新
    NSString *resultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1229990827"] encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *infoDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (infoDictionary[@"results"]) {
        
        NSArray *resultArray = infoDictionary[@"results"];
        NSString *version = [resultArray firstObject][@"version"];
        if (version.length > 0)
            [self checkUpdate:[version floatValue]];
        else
            [self start];
    }
    else {
        
        [self start];
    }
}

- (void)start {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"language"]) {
        
        LanguagePickerView *languagePickerView = [self.storyboard instantiateViewControllerWithIdentifier:@"LanguagePickerView"];
        [self presentViewController:languagePickerView animated:NO completion:^{
            
            splashCoverView.alpha = 0.6f;
        }];
    }
    else {
        
        [LoginAPI sharedInstance].delegate = self;
        [[LoginAPI sharedInstance] autoLogin];
    }
}

- (void)checkUpdate:(CGFloat)version {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CGFloat localVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    if (localVersion < version) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"检测到有更新的版本，请前往下载") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"立即下载") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1229990827?l=zh&ls=1&mt=8"]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishLogin:(LoginAPI *)loginAPI {
    
    MainTabBarController *mainTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:mainTabBarController animated:NO completion:nil];
}

- (void)didFailedLogin:(LoginAPI *)loginAPI {
    
    MainTabBarController *mainTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:mainTabBarController animated:NO completion:nil];
}

@end
