//
//  LanguagePickerView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/16.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "LanguagePickerView.h"
#import "UserAPI.h"

@interface LanguagePickerView ()

@end

@implementation LanguagePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//    iconImageView.image = [UIImage imageNamed:icon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0f animations:^{
        
        backgroundCoverView.alpha = 0.6f;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f animations:^{
            
            buttonContainerView.alpha = 1.0f;
        } completion:nil];
    }];
}

- (IBAction)languageButtonClicked:(id)sender {
    
    UIButton *button = sender;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (button.tag == 1)
        appDelegate.language = @"zh-Hans";
    else if (button.tag == 2)
        appDelegate.language = @"en";
    else if (button.tag == 3)
        appDelegate.language = @"ja";
    else if (button.tag == 4)
        appDelegate.language = @"ko";
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.language forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
