//
//  MessageCell.h
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell {
    
    UILabel *contentLabel;
    UIView *line;
    UILabel *replyContentLabel;
    UILabel *createDateLabel;
}

@property (nonatomic, strong) Message *message;

+ (CGFloat)suggestHeightWithMessage:(Message *)message;

- (void)setupSubviews;
- (void)setupSubviewsWithWidth:(CGFloat)width;

@end
