//
//  TextEditTableCell.h
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditTableCell : UITableViewCell <UITextFieldDelegate>

typedef void(^valueChangedBlock)(NSString *text);

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UITextField *valueText;
@property (nonatomic, assign) BOOL alwaysUppercase;

@property (nonatomic, copy) valueChangedBlock valueChangedBlock;

@end
