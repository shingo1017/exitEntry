//
//  ImageInfoTableCell.h
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageInfoTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *valueImageView;
@property (nonatomic, assign) CGSize imageSize;

@end
