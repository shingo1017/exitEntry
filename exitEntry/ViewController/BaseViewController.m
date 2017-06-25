//
//  BaseViewController.m
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "BaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BaseViewController () {
    
    CGFloat _orginalHeightOfViewNeedResize;
}

@property(nonatomic, strong) NSString *emptyDataTipsTitle;
@end

@implementation BaseViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    loadingView = (LoadingView *) [UIView viewWithName:@"LoadingView"];
    loadingView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];

    [loadingView addRetryButtonHandler:self action:@selector(reloadData)];
}

- (void)viewWillAppear:(BOOL)animated {


    NSLog(@"View will appear in :%@ ", [self class]);

    [super viewWillAppear:animated];

//    if (MAIN_NAVIGATIONCONTROLLER.viewControllers.count == 1)
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    else
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    if (!_ignoreCheckNetwork)
        [loadingView checkNetwork];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSLog(@"View will disappear in :%@", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)emptyDataTipsTitle {
    if (nil == _emptyDataTipsTitle) {
        _emptyDataTipsTitle = @"暂无数据";
    }
    return _emptyDataTipsTitle;
}

- (void)dealloc {

    [loadingView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)startLoading {

    if (!NETWORK)
        [loadingView showNoNetwork];
    else
        [loadingView startLoadingAnimation];
//        [loadingView startLoadingAnimation];
//    else
//        [loadingView showNoNetwork];
}

- (void)stopLoading {

    [loadingView stopLoadingAnimation];

    if (NETWORK)
        loadingView.hidden = YES;
    else
        [loadingView showNoNetwork];
}

- (void)reloadData {


}

- (void)reloadServerData {

    isRefreshReloading = YES;
}

#pragma mark - Empty Data Trigger


- (void)presentEmptyDataInScrollView:(UIScrollView *)scrollView {

    if (nil == scrollView) {
        return;
    }
    [self presentEmptyDataInScrollView:scrollView withTitle:nil];
}

- (void)presentEmptyDataInScrollView:(UIScrollView *)scrollView withTitle:(NSString *)title {

    if (nil == scrollView) {
        return;
    }

    title = (nil == title) ? @"暂无数据" : title;

    self.emptyDataTipsTitle = title;

    [scrollView setEmptyDataSetDelegate:self];
    [scrollView setEmptyDataSetSource:self];

    [scrollView reloadEmptyDataSet];
}

- (void)handleRefreshFooterWithTotalData:(NSArray *)data singleData:(NSArray *)singleData inScrollView:(UIScrollView *)scrollView {
    BOOL isHidden = (nil == data || data.count <= 0 || data.count < 10);
    if (nil == scrollView || nil == scrollView.mj_footer) {
        return;
    }
    //if data count less than 10 , show no more tips
    if (nil != singleData && singleData.count < 10) {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }


    [scrollView.mj_footer setHidden:isHidden];
}


#pragma mark - DZN Empty Data Delegate & Data source

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:self.emptyDataTipsTitle attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
            NSForegroundColorAttributeName: SUMMARY_COLOR
    }];
}

@end
