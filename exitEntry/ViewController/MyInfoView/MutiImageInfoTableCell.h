//
//  ImageInfoTableCell.h
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutiImageInfoTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *valueCollectionView;
@property (nonatomic, assign) CGSize imageSize;

@end
