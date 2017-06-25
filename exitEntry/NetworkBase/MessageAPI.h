//
//  MessageAPI.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/19.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "CommonAPI.h"

@interface MessageAPI : CommonAPI

- (void)getMessagesWithPage:(NSInteger)page;
- (void)leaveMessage:(NSString *)message;

@end
