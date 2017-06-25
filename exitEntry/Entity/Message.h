//
//  Message.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Message : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) BOOL isReply;

@end
