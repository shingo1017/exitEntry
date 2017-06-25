//
//  TextEditTableCell.m
//  copybook
//
//  Created by 尹楠 on 15/11/26.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "TextEditTableCell.h"

@implementation TextEditTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _captionLabel.textColor = TITLE_COLOR;
    _valueText.textColor = TITLE_COLOR;
    _valueText.placeholder = text(@"未设置");
    _valueText.delegate = self;
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
        _valueText.right = SCREEN_WIDTH - 15.0f;
    else
        _valueText.right = SCREEN_WIDTH - 35.0f;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.alwaysUppercase && string.length > 0) {
        
        char commitChar = [string characterAtIndex:0];
        if (commitChar > 96 && commitChar < 123) {
            
            //小写变成大写
            NSString * uppercaseString = string.uppercaseString;
            NSString * str1 = [textField.text substringToIndex:range.location];
            NSString * str2 = [textField.text substringFromIndex:range.location];
            textField.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2];
            
            _valueChangedBlock(textField.text);
            
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)editDidChanged:(id)sender {
    
    _valueChangedBlock(_valueText.text);
}

- (void)dismissKeyboard {
    
    [_valueText resignFirstResponder];
}

@end
