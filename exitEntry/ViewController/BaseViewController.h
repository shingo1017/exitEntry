//
//  BaseViewController.h
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BaseViewController : UIViewController <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {

    LoadingView *loadingView;

    BOOL isRefreshReloading;
}

@property(nonatomic, assign) BOOL ignoreCheckNetwork;

- (void)startLoading;

- (void)stopLoading;

- (void)reloadData;

- (void)reloadServerData;


#pragma mark - Empty Data Stuff

- (void)presentEmptyDataInScrollView:(UIScrollView *)scrollView;

- (void)presentEmptyDataInScrollView:(UIScrollView *)scrollView withTitle:(NSString *)title;


#pragma mark - Refresh Footer

- (void)handleRefreshFooterWithTotalData:(NSArray *)data singleData:(NSArray *)singleData inScrollView:(UIScrollView *)scrollView;


@end
