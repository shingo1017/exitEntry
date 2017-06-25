//
//  ImageInfoTableCell.m
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "ImageInfoTableCell.h"

@implementation ImageInfoTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    _captionLabel.textColor = TITLE_COLOR;
    _valueImageView.contentMode = UIViewContentModeScaleAspectFill;
    _valueImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageSize:(CGSize)imageSize {
    
    _imageSize = imageSize;
    
    _valueImageView.width = _imageSize.width;
    _valueImageView.height = _imageSize.height;
    
    if (self.accessoryType == UITableViewCellAccessoryNone)
        _valueImageView.right = SCREEN_WIDTH - 15.0f;
    else
        _valueImageView.right = SCREEN_WIDTH - 35.0f;
}

@end
