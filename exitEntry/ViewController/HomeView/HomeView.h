//
//  HomeView.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "CollectionSectionWidget.h"
#import "TableSectionWidget.h"
#import "NavigationBarWidget.h"

@interface HomeView : UIViewController <SDCycleScrollViewDelegate, CollectionSectionWidgetDelegate, TableSectionWidgetDelegate> {
    
    IBOutlet NavigationBarWidget *navigationBarWidget;
    IBOutlet UIScrollView *_mainScrollView;
    SDCycleScrollView *_bannerView;
    IBOutlet UIButton *_bookButton;
    IBOutlet UIButton *_regulationButton;
    IBOutlet UIButton *_messageButton;
    CollectionSectionWidget *_cultureCollectionSectionWidget;
    TableSectionWidget *_regulationTableSectionWidget;
    IBOutlet UIButton *_proclamationButton;
    IBOutlet UIButton *_serviceButton;
    IBOutlet UIButton *_reminderButton;
    IBOutlet UIButton *_moreButton;
}

@end

