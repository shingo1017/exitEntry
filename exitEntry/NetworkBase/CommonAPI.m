//
//  CommonAPI.m
//  copybook
//
//  Created by 尹楠 on 16/11/7.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "CommonAPI.h"

#define GET_CONFIGS_URL     @"api/config"
#define GET_BANNERS_URL     @"api/banner"
#define FEEDBACK_URL        @"api/user/%@/message"

@implementation CommonAPI

- (void)getConfigs {
    
    self.requestURL = GET_CONFIGS_URL;
    self.method = NetworkBaseMethodGet;
    
    [self startRequest];
}

- (void)getHomeBanners {
    
//    NSArray *mockData = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"getBanners.plist")];
//    if (nil != self.successBlock)
//        self.successBlock(mockData);
    
    self.requestURL = GET_BANNERS_URL;
    self.method = NetworkBaseMethodGet;
    
    [self startRequest];
}

- (void)handleResponse:(id)response {
    
    [self handleResponse:response withError:nil];
}

- (void)handleResponse:(id)response withError:(NSError *)error {
    
    NSLog(@"response = %@", response);
    
    [MBProgressHUD hideHUDs];
    
    if (error) {
        
        //API发生系统错误

        if (nil != self.failBlock)
            self.failBlock(-1, text(@"服务器无响应，请稍后重试"));
        else
            [MBProgressHUD showError:text(@"服务器无响应，请稍后重试") toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    else if (nil == response) {
        
        //API返回无内容响应
        if (nil != self.failBlock)
            self.failBlock(-1, text(@"服务器无响应，请稍后重试"));
        else
            [MBProgressHUD showError:text(@"服务器无响应，请稍后重试") toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    else {
        
        if ([response[@"code"] integerValue] == 0) {
            
            //API执行成功
            if (nil != self.successBlock)
                self.successBlock(response[@"data"]);
        }
        else {
            
            //API发生逻辑错误
            if (nil != self.failBlock)
                self.failBlock([response[@"code"] integerValue], response[@"msg"]);
            else
                [MBProgressHUD showError:response[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

@end
