//
//  DateTransformer.m
//  copybook
//
//  Created by 尹楠 on 16/12/28.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "JSONValueTransformer+DateTransformer.h"

@implementation JSONValueTransformer (DateTransformer)

-(NSDate*)__NSDateFromNSString:(NSString*)string {
    
    if (string.length == @"yyyy-MM-dd".length)
        return [string date];
    else if (string.length == @"yyyy-MM-dd hh:mm:ss".length)
        return [string datetime];
    else
        return nil;
}

-(NSString*)__JSONObjectFromNSDate:(NSDate*)date
{
    static dispatch_once_t onceOutput;
    static NSDateFormatter *outputDateFormatter;
    dispatch_once(&onceOutput, ^{
        outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return [outputDateFormatter stringFromDate:date];
}

@end
