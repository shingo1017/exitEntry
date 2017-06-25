//
//  ArticleDetailView.h
//  Entlphone
//
//  Created by wangyanan on 14-8-17.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NavigationBarWidget.h"
#import "Article.h"

@interface ArticleDetailView : BaseViewController <UIWebViewDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *createDateLabel;
    IBOutlet UIWebView *contentWebView;
}

@property (nonatomic, strong) Article *article;
@property (nonatomic, assign) BOOL showDateTime;

@end
