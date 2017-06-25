//
//  Dictionary.h
//  nucEV
//
//  Created by 尹楠 on 15/3/10.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dictionary : NSObject

/*!
 @property
 @abstract 标题。
 */
@property (nonatomic, retain) NSString *text;

/*!
 @property
 @abstract 值。
 */
@property (nonatomic, retain) NSString *value;

+ (void)setLanguageArray:(NSArray *)array;
+ (NSArray *)languageArray;

+ (void)setCountryArray:(NSArray *)array;
+ (NSArray *)countryArray;

+ (void)setIdentityTypeArray:(NSArray *)array;
+ (NSArray *)identityTypeArray;

+ (void)setPersonTypeArray:(NSArray *)array;
+ (NSArray *)personTypeArray;

+ (void)setPersonAreaTypeArray:(NSArray *)array;
+ (NSArray *)personAreaTypeArray;

+ (void)setGenderArray:(NSArray *)array;
+ (NSArray *)genderArray;

+ (void)setOccupationArray:(NSArray *)array;
+ (NSArray *)occupationArray;

+ (void)setVisaTypeArray:(NSArray *)array;
+ (NSArray *)visaTypeArray;

+ (void)setEntryPortArray:(NSArray *)array;
+ (NSArray *)entryPortArray;

+ (void)setStayReasonArray:(NSArray *)array;
+ (NSArray *)stayReasonArray;

+ (void)setPoliceStationArray:(NSArray *)array;
+ (NSArray *)policeStationArray;

+ (void)setCommunityDictionary:(NSDictionary *)dictionary;
+ (NSArray *)communityArrayWithPoliceStation:(NSString *)policeStation;

+ (void)setHouseTypeArray:(NSArray *)array;
+ (NSArray *)houseTypeArray;

+ (NSInteger)indexForValue:(NSString *)value inDictionaries:(NSArray *)dictionaries;
+ (NSString *)textForValue:(NSString *)value inDictionaries:(NSArray *)dictionaries;
+ (NSArray *)dictionariesWithDictionary:(NSDictionary *)dictionary;

@end
