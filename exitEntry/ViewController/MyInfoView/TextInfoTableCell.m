//
//  TextInfoTableCell.m
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "TextInfoTableCell.h"

@implementation TextInfoTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    _captionLabel.textColor = TITLE_COLOR;
    _captionLabel.numberOfLines = 0;
    _valueLabel.textColor = TITLE_COLOR;
    _valueLabel.numberOfLines = 0;
    _valueLabel.text = text(@"未设置");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_iconImageView.image)
        _captionLabel.left = _iconImageView.right + 7;
    else
        _captionLabel.left = 15;
        
    if (self.accessoryType == UITableViewCellAccessoryNone)
        _valueLabel.right = SCREEN_WIDTH - 15.0f;
    else
        _valueLabel.right = SCREEN_WIDTH - 35.0f;
}

@end
