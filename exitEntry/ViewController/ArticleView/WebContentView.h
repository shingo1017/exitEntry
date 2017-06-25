//
//  WebContentView.h
//  Entlphone
//
//  Created by wangyanan on 14-8-17.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NavigationBarWidget.h"

@interface WebContentView : BaseViewController <UIWebViewDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    
    UIWebView *contentWebView;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *html;

@end
