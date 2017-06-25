//
//  FeedbackView.h
//  copybook
//
//  Created by 尹楠 on 16/11/23.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationBarWidget.h"

@interface FeedbackView : BaseViewController <NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UITextView *contentText;
}

@end
