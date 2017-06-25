//
//  Message.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"content" : @"message",
                                                                  @"replyContent" : @"content",
                                                                  @"createDate" : @"created_at",
                                                                  @"isReply" : @"type",
                                                                  }];
}

@end
