//
//  Article.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "Article.h"

@implementation Article

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"title" : @"title",
                                                                  @"imageUrl" : @"cover",
                                                                  @"summary" : @"intro",
                                                                  @"content" : @"content",
                                                                  @"createDate" : @"created_at",
                                                                  }];
}

@end
