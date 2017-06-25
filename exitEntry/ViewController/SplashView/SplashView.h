//
//  SplashView.h
//  novel
//
//  Created by 尹楠 on 16/2/16.
//  Copyright © 2016年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAPI.h"

@interface SplashView : UIViewController <LoginDelegate> {
    
    IBOutlet UIImageView *splashImageView;
    IBOutlet UIView *splashCoverView;
    IBOutlet UIImageView *iconImageView;
}

@end

