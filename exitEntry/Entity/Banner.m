//
//  Banner.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "Banner.h"

@implementation Banner

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"imageUrl": @"image",
                                                                  @"contentUrl": @"url",
                                                                  }];
}

@end
