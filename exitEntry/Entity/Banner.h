//
//  Banner.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/18.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Banner : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, copy) NSString *contentUrl;

@end
