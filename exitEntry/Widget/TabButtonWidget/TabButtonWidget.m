//
//  TabButtonWidget.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/30.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "TabButtonWidget.h"

@implementation TabButtonWidget

- (void)setupViewsWithWidth:(CGFloat)width {
    
    if (!imageView) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 27) / 2, 3, 27, 27)];
        [self addSubview:imageView];
    }
    if (!titleLabel) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, width, self.height - imageView.bottom - 3)];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont systemFontOfSize:kFontSizeTitle];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    if (!button) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width, self.height);
        button.tag = self.index;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    self.selected = NO;
}

- (void)buttonClicked:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickedTabButtonWidget:)])
        [_delegate didClickedTabButtonWidget:self];
}

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    if (_selected) {
        
        imageView.image = imageView.image = [UIImage imageNamed:self.imageNameStateSelected];
        titleLabel.textColor = self.titleColorStateSelected;
    }
    else {
        
        imageView.image = imageView.image = [UIImage imageNamed:self.imageNameStateNormal];
        titleLabel.textColor = self.titleColorStateNormal;
    }
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    titleLabel.text = _title;
}

@end
