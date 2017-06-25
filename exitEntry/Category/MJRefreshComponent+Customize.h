//
//  MJRefreshComponent+Customize.h
//  copybook
//
//  Created by Han on 16/11/21.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshComponent (Customize)


+ (void)addCustomizeRefreshInScrollView:(UIScrollView *)scrollView withHeaderRefreshBlock:(void (^)(void))headerRefreshBlcok withFooterRefreshBlock:(void (^)(void))footerRefreshBlock;

@end
