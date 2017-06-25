//
//  NSData+Additions.h
//  copybook
//
//  Created by 尹楠 on 15/10/27.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(unsigned int) lineLength;

@end
