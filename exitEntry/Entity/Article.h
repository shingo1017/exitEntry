//
//  Article.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Article : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createDate;

@end
