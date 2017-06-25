//
//  NSDate+Additions.h
//  copybook
//
//  Created by Shingo Yabuki on 12-6-4.
//  Copyright (c) 2012年 c2y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)now;
+ (NSString *)weekDayText:(NSInteger)weekday;

- (NSDate *)addDays:(NSInteger)days;
- (NSString *)onlineDateFormattedString;
- (NSString *)yearmonthdayDateFormattedString;
- (NSString *)timeDateFormattedString;
- (NSString *)longDateFormattedString;
- (NSString *)vipValidityDateFormattedString;

- (NSString *)stringValue;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSInteger)season;
- (NSInteger)age;
- (NSString *)constellation;
- (NSString *)UMTimeInterval;

@end
