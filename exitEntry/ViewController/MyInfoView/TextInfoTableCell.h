//
//  TextInfoTableCell.h
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInfoTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end
