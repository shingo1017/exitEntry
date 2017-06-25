//
//  NoDataTableViewCell.m
//  Entlphone
//
//  Created by wangyanan on 14-8-1.
//  Copyright (c) 2014年 Shingo. All rights reserved.
//

#import "NoDataTableViewCell.h"

@implementation NoDataTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = BACKGROUND_COLOR;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font=[UIFont systemFontOfSize:kFontSizeHeadline];
    self.textLabel.textColor = TITLE_COLOR;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.textLabel setFrame:CGRectMake(0, self.frame.size.height / 2 - 30, self.frame.size.width, 20)];
    
    self.detailTextLabel.font=[UIFont systemFontOfSize:kFontSizeTitle];
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.detailTextLabel setFrame:CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, 20)];
}

@end
