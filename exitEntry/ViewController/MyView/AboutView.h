//
//  AboutView.h
//  Entlphone
//
//  Created by 尹楠 on 15/4/1.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@interface AboutView : BaseViewController
{
    IBOutlet NavigationBarWidget *navigationBarWidget;
    
    IBOutlet UIImageView * imageView;//毒药图标
    IBOutlet UILabel * versionLabel;//版本号
    IBOutlet UILabel * feedbackLabel;//反馈
    IBOutlet UIView * line;//分割线
    IBOutlet UILabel * companyName1;//公司名中文
}
@end
