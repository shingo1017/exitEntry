//
//  PhotoSampleView.h
//  exitEntry
//
//  Created by 尹楠 on 17/4/11.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarWidget.h"

@interface PhotoSampleView : UIViewController <UIScrollViewDelegate, NavigationBarWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIScrollView *zoomScrollView;
    IBOutlet UIImageView *photoImageView;
}

@property (nonatomic, copy) NSString *photoName;

@end
