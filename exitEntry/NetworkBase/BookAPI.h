//
//  BookAPI.h
//  copybook
//
//  Created by 尹楠 on 16/11/7.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "CommonAPI.h"
#import "BookInfo.h"

@interface BookAPI : CommonAPI

- (void)getBookStatus;
- (void)uploadPhoto:(UIImage *)photo;
- (void)submitInfo;
- (void)writeOffInfo;

@end
