//
//  MJRefreshComponent+Customize.m
//  copybook
//
//  Created by Han on 16/11/21.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "MJRefreshComponent+Customize.h"
#import "MJRefreshAutoNormalFooter.h"

@implementation MJRefreshComponent (Customize)

+ (void)addCustomizeRefreshInScrollView:(UIScrollView *)scrollView withHeaderRefreshBlock:(void (^)(void))headerRefreshBlcok withFooterRefreshBlock:(void (^)(void))footerRefreshBlock {


    // Set refresh header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshBlcok];

    [header.stateLabel setHidden:YES];
    [header.lastUpdatedTimeLabel setHidden:YES];
    [scrollView setMj_header:header];

    //Set refresh footer
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footerRefreshBlock];
    [footer.stateLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [footer.stateLabel setTextColor:TITLE_COLOR];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];

    [scrollView setMj_footer:footer];


}


@end
