//
//  WebContentView.m
//  Entlphone
//
//  Created by wangyanan on 14-8-17.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import "WebContentView.h"

@interface WebContentView ()

@end

@implementation WebContentView

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
    self.view.backgroundColor = BACKGROUND_COLOR;

    navigationBarWidget.title = self.title;
    navigationBarWidget.delegate = self;
    
    contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    contentWebView.delegate = self;
    contentWebView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentWebView];
    contentWebView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    if (_url.length > 0) {
        
        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        contentWebView.scalesPageToFit = YES;
    }
    else if (_html.length > 0) {
        
        [contentWebView loadHTMLString:_html baseURL:nil];
        contentWebView.scalesPageToFit = NO;
    }
    
    [self startLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    NSLog(@"%@", contentWebView.request.URL.absoluteString );
    if (![contentWebView canGoBack]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        [contentWebView goBack];
    }
}

#pragma mark UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //_url = contentWebView.request.URL.absoluteString;
    
    [self stopLoading];
    
    
    NSLog(@"%@", webView.request.URL.absoluteString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self stopLoading];
}

@end
