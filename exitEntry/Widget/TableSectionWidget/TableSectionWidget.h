//
//  TableSectionWidget.h
//  novel
//
//  Created by 尹楠 on 15/11/24.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderWidget.h"
#import "Article.h"

@protocol TableSectionWidgetDelegate;

@interface TableSectionWidget : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    SectionHeaderWidget *sectionHeaderWidget;
    UITableView *tableView;
}

@property (nonatomic, weak) id<TableSectionWidgetDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *articles;
@property (nonatomic, assign) BOOL showDateTime;

- (void)reloadData;
- (CGFloat)suggestHeightWithShowDateTime:(BOOL)showDateTime;

@end

@protocol TableSectionWidgetDelegate <NSObject>

@optional

- (void)didClickedTableSectionWidgetRightButton:(TableSectionWidget *)tableSectionWidget;
- (void)tableSectionWidget:(TableSectionWidget *)tableSectionWidget didClickedArticle:(Article *)article;

@end
