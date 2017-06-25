//
//  MessageAPI.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/19.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "MessageAPI.h"

#define GET_MESSAGES_URL     @"api/user/%@/notification"
#define LEAVE_MESSAGE_URL    @"api/user/%@/message"

@implementation MessageAPI

- (void)getMessagesWithPage:(NSInteger)page {
    
    self.requestURL = [NSString stringWithFormat:GET_MESSAGES_URL, [User defaultUser].id];
    self.httpHeaderField = [NetworkBase authorizedHeader];
    self.method = NetworkBaseMethodGet;
    self.params = @{ @"page" : @(page) };
    
    [self startRequest];
}

- (void)leaveMessage:(NSString *)message {
    
    self.params = @{
                    @"content": message,
                    };
    self.requestURL = [NSString stringWithFormat:LEAVE_MESSAGE_URL, [User defaultUser].id];
    self.method = NetworkBaseMethodPost;
    self.httpHeaderField = [NetworkBase authorizedHeader];
    
    [self startRequest];
}

@end
