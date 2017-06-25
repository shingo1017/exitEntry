//
//  Dictionary.m
//  nucEV
//  消息通知的评论内容
//  Created by 尹楠 on 15/3/10.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import "Dictionary.h"

static NSArray *languageArray;
static NSArray *countryArray;
static NSArray *identityTypeArray;
static NSArray *personTypeArray;
static NSArray *personAreaTypeArray;
static NSArray *genderArray;
static NSArray *occupationArray;
static NSArray *visaTypeArray;
static NSArray *entryPortArray;
static NSArray *stayReasonArray;
static NSArray *policeStationArray;
static NSDictionary *communityDictionary;
static NSArray *houseTypeArray;

@implementation Dictionary

+ (void)setLanguageArray:(NSArray *)array {
    
    languageArray = array;
}

+ (NSArray *)languageArray {
    
    if (!languageArray)
        languageArray = [Dictionary dictionariesWithDictionary:[NSDictionary dictionaryWithContentsOfFile:FILE_BUNDLE_PATH(@"languageArray.plist")]];
    return languageArray;
}

+ (void)setCountryArray:(NSArray *)array {
    
    countryArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((Dictionary *)obj1).text compare:((Dictionary *)obj2).text];
    }];
}

+ (NSArray *)countryArray {
    
    if (!countryArray)
        countryArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"countryArray.plist")];
    return countryArray;
}

+ (void)setIdentityTypeArray:(NSArray *)array {
    
    identityTypeArray = array;
}

+ (NSArray *)identityTypeArray {
    
    if (!identityTypeArray)
        identityTypeArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"identityTypeArray.plist")];
    return identityTypeArray;
}

+ (void)setPersonTypeArray:(NSArray *)array {
    
    personTypeArray = array;
}

+ (NSArray *)personTypeArray {
    
    if (!personTypeArray)
        personTypeArray = [Dictionary dictionariesWithDictionary:[NSDictionary dictionaryWithContentsOfFile:FILE_BUNDLE_PATH(@"personTypeArray.plist")]];
    return personTypeArray;
}

+ (void)setPersonAreaTypeArray:(NSArray *)array {
    
    personAreaTypeArray = array;
}

+ (NSArray *)personAreaTypeArray {
    
    if (!personAreaTypeArray)
        personAreaTypeArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"personAreaTypeArray.plist")];
    return personAreaTypeArray;
}

+ (void)setGenderArray:(NSArray *)array {
    
    genderArray = array;
}

+ (NSArray *)genderArray {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *fileName = [NSString stringWithFormat:@"genderArray_%@.plist", appDelegate.language];
    
    if (!genderArray)
        genderArray = [Dictionary dictionariesWithDictionary:[NSDictionary dictionaryWithContentsOfFile:FILE_BUNDLE_PATH(fileName)]];
    return genderArray;
}

+ (void)setOccupationArray:(NSArray *)array {
    
    occupationArray = array;
}

+ (NSArray *)occupationArray {
    
    if (!occupationArray)
        occupationArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"occupationArray.plist")];
    return occupationArray;
}

+ (void)setVisaTypeArray:(NSArray *)array {
    
    visaTypeArray = array;
}

+ (NSArray *)visaTypeArray {
    
    if (!visaTypeArray)
        visaTypeArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"visaTypeArray.plist")];
    return visaTypeArray;
}

+ (void)setEntryPortArray:(NSArray *)array {
    
    entryPortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((Dictionary *)obj1).text compare:((Dictionary *)obj2).text];
    }];
}

+ (NSArray *)entryPortArray {
    
    if (!entryPortArray)
        entryPortArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"entryPortArray.plist")];
    return entryPortArray;
}

+ (void)setStayReasonArray:(NSArray *)array {
    
    stayReasonArray = array;
}

+ (NSArray *)stayReasonArray {
    
    if (!stayReasonArray)
        stayReasonArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"stayReasonArray.plist")];
    return stayReasonArray;
}

+ (void)setPoliceStationArray:(NSArray *)array {
    
    policeStationArray = array;
}

+ (NSArray *)policeStationArray {
    
    if (!policeStationArray)
        policeStationArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"policeStationArray.plist")];
    return policeStationArray;
}

+ (void)setCommunityDictionary:(NSDictionary *)dictionary {
    
    communityDictionary = dictionary;
}

+ (NSArray *)communityArrayWithPoliceStation:(NSString *)policeStation {
    
    NSArray *communityArray = [Dictionary dictionariesWithDictionary:communityDictionary[policeStation]];
    
    return communityArray;
}

+ (void)setHouseTypeArray:(NSArray *)array {
    
    houseTypeArray = array;
}

+ (NSArray *)houseTypeArray {
    
    if (!houseTypeArray)
        houseTypeArray = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"houseTypeArray.plist")];
    return houseTypeArray;
}

+ (NSString *)textForValue:(NSString *)value inDictionaries:(NSArray *)dictionaries {
    
    NSInteger index = [Dictionary indexForValue:value inDictionaries:dictionaries];
    if (index == NSNotFound)
        return text(@"未设置");
    else {
        
        Dictionary *dictionary = dictionaries[index];
        return dictionary.text;
    }
}

+ (NSInteger)indexForValue:(NSString *)value inDictionaries:(NSArray *)dictionaries {
    
    NSInteger index = NSNotFound;
    
    NSInteger i = 0;
    for (Dictionary *dictionary in dictionaries) {
        
        if ([dictionary.value isEqualToString:value]) {
            
            index = i;
            break;
        }
        
        i++;
    }
    
    return index;
}

+ (NSArray *)dictionariesWithDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *dictionaries = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary.allKeys) {
        
        Dictionary *dictionaryEntity = [Dictionary new];
        dictionaryEntity.text = dictionary[key];
        dictionaryEntity.value = key;
        [dictionaries addObject:dictionaryEntity];
    }
    return dictionaries;
}

@end
