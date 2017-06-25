//
//  CommonAPI.h
//  copybook
//
//  Created by 尹楠 on 16/11/7.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "NetworkBase.h"

@interface CommonAPI : NetworkBase

- (void)getConfigs;

- (void)getResizedImageUrlWithWidth:(CGFloat)width height:(CGFloat)height;

- (void)getHomeBanners;

- (void)getMyMessages;

@end
