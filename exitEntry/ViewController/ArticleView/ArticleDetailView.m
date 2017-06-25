//
//  ArticleDetailView.m
//  Entlphone
//
//  Created by wangyanan on 14-8-17.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import "ArticleDetailView.h"
#import "ArticleAPI.h"

@interface ArticleDetailView ()

@end

@implementation ArticleDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    navigationBarWidget.title = text(@"文章详情");
    navigationBarWidget.delegate = self;
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:kFontSizeTitle];
    titleLabel.numberOfLines = 0;
    createDateLabel.height = 30;
    createDateLabel.textColor = SUMMARY_COLOR;
    createDateLabel.font = [UIFont systemFontOfSize:kFontSizeSummary];
    contentWebView.scrollView.scrollEnabled = NO;
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    
    ArticleAPI *articleAPI = [ArticleAPI new];
    [articleAPI setSuccessBlock:^(id result) {
        
        _article = [[Article alloc] initWithDictionary:result error:nil];
        
        [self fillData];
    }];
    [articleAPI getArticle:_article.id];
}

- (void)fillData {
    
    titleLabel.text = _article.title;
    createDateLabel.text = [_article.createDate stringValue];
    
    [contentWebView loadHTMLString:_article.content baseURL:nil];
    contentWebView.scalesPageToFit = YES;
    
    [self fitSize];
}

- (void)fitSize {
    
    titleLabel.height = [_article.title heightOfAttributedText:[_article.title attributedStringWithFontSize:kFontSizeTitle] width:SCREEN_WIDTH - 30];
    
    if (_showDateTime) {
        
        createDateLabel.top = titleLabel.bottom + 5;
        createDateLabel.height = 30;
    }
    else {
        
        createDateLabel.top = titleLabel.bottom + 10;
        createDateLabel.height = 0;
    }
    [createDateLabel lineDockBottomWithColor:TITLE_COLOR];
    
    contentWebView.top = createDateLabel.bottom + 10;
    contentWebView.height = contentWebView.scrollView.contentSize.height;
    
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentWebView.bottom + 10);
}

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    if (![contentWebView canGoBack]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        [contentWebView goBack];
    }
}

#pragma mark UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    
    [self fitSize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
}

@end
