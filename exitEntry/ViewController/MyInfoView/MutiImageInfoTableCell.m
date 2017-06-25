//
//  MutiImageInfoTableCell.m
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "MutiImageInfoTableCell.h"
#import "HYCollectViewAlignedLayout.h"

@implementation MutiImageInfoTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    _captionLabel.textColor = TITLE_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageSize:(CGSize)imageSize {
    
    _imageSize = imageSize;
}

@end
