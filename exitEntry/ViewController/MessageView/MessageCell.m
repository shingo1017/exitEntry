//
//  MessageCell.m
//  Entlphone
//
//  Created by JinYing020036 on 15/10/21.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)setupSubviews {
    
    [self setupSubviewsWithWidth:SCREEN_WIDTH];
}

- (void)setupSubviewsWithWidth:(CGFloat)width {
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!contentLabel) {
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width - 20, kFontSizeTitle)];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:kFontSizeTitle];
        contentLabel.textColor = TITLE_COLOR;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:contentLabel];
    }
    
    if (!line) {
        
        line = [[UIView alloc] initWithFrame:CGRectMake(contentLabel.left, contentLabel.bottom + 10, width - 20, 0.5)];
        line.backgroundColor = BORDER_COLOR;
        [self addSubview:line];
    }
    
    if (!replyContentLabel) {
        
        replyContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.left, line.bottom + 10, width - 20, kFontSizeSummary)];
        replyContentLabel.numberOfLines = 1;
        replyContentLabel.font = [UIFont systemFontOfSize:kFontSizeSummary];
        replyContentLabel.textColor = SUMMARY_COLOR;
        replyContentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:replyContentLabel];
    }
    
    if (!createDateLabel)
    {
        createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.left, replyContentLabel.bottom + 5, 150, kFontSizeSummary)];
        createDateLabel.font = [UIFont systemFontOfSize:kFontSizeSummary];
        createDateLabel.textColor = SUMMARY_COLOR;
        createDateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:createDateLabel];
    }
}

- (void)setMessage:(Message *)message {
    
    _message = message;
    
    if (_message) {
        
        contentLabel.text = _message.content;
        contentLabel.attributedText = [contentLabel.text attributedStringWithFontSize:contentLabel.font.pointSize textColor:contentLabel.textColor];
        contentLabel.height = [contentLabel.text heightOfAttributedText:contentLabel.attributedText width:contentLabel.width];
        createDateLabel.text = [_message.createDate longDateFormattedString];
        
        if (_message.isReply) {
            
            line.hidden = NO;
            line.top = contentLabel.bottom + 5;
            replyContentLabel.text = _message.replyContent;
            [replyContentLabel sizeToFit];
            replyContentLabel.top = line.bottom + 8;
            createDateLabel.top = replyContentLabel.bottom + 8;
        }
        else {
            
            line.hidden = YES;
            createDateLabel.top = contentLabel.bottom + 8;
        }
    }
}

+ (CGFloat)suggestHeightWithMessage:(Message *)message {
    
    CGFloat height = 10.0f;
    
    NSString *content = message.content;
    
    height += [content heightOfAttributedText:[content attributedStringWithFontSize:kFontSizeTitle] width:SCREEN_WIDTH - 20];
    
    if (message.isReply) {
        
        height += 16.0f;
        
        height += kFontSizeSummary;
        
        height += 8.0f;
        
        height += kFontSizeSummary;
        
        height += 10.0f;
    }
    else {
        
        height += 8.0f;
        
        height += kFontSizeSummary;
        
        height += 10.0f;
    }
    
    return height;
}

@end
