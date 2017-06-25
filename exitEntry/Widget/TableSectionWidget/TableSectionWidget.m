//
//  TableSectionWidget.m
//  novel
//
//  Created by 尹楠 on 15/11/24.
//  Copyright © 2015年 Shingo. All rights reserved.
//

#import "TableSectionWidget.h"
#import "TableSectionCell.h"
#import "NoDataTableViewCell.h"

@interface TableSectionWidget ()

@end

@implementation TableSectionWidget

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
//        [self lineDockBottomWithColor:GRAY_225_COLOR];
        
        sectionHeaderWidget = (SectionHeaderWidget *)[UIView viewWithName:@"SectionHeaderWidget"];
        sectionHeaderWidget.frame = CGRectMake(0, 0, self.width, 50.0f);
        sectionHeaderWidget.rightButtonTitle = text(@"更多");
        sectionHeaderWidget.rightButtonEnabled = NO;
        [sectionHeaderWidget addRightButtonClickedHandler:self action:@selector(moreButtonClicked:)];
        [self addSubview:sectionHeaderWidget];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35.0f, frame.size.width, frame.size.height - 35.0f) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = BORDER_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
    }
    
    return self;
}

- (void)moreButtonClicked:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickedTableSectionWidgetRightButton:)])
        [_delegate didClickedTableSectionWidgetRightButton:self];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    if (_title)
        sectionHeaderWidget.title = _title;
}

- (void)setArticles:(NSArray *)articles {
    
    _articles = articles;
    
    if (_articles) {
        
        [tableView reloadData];
    }
}

- (void)reloadData {
    
    [tableView reloadData];
}

- (CGFloat)suggestHeightWithShowDateTime:(BOOL)showDateTime {
    
    CGFloat height = 0;
    
    if (_articles.count > 0) {
        
        for (Article *article in _articles) {
            
            height += [TableSectionCell suggestHeightWithArticle:article showDateTime:showDateTime];
        }
    }
    else
        height = floatByScale(200.0f);
    
    tableView.top = 35.0f;
    tableView.height = height;
    
    return tableView.top + height;
}

#pragma mark UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_articles.count > 0)
        return _articles.count;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_articles.count > 0) {
        
        Article *article = _articles[indexPath.row];
        CGFloat rowHeight = [TableSectionCell suggestHeightWithArticle:article showDateTime:_showDateTime];
        return rowHeight;
    }
    else
        return floatByScale(200.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_articles.count > 0) {
        
        NSString *identifier = @"TableSectionCell";
        TableSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            
            cell = [[TableSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            [cell setupSubviews];
        }
        
        Article *article = [_articles objectAtIndex:indexPath.row];
        cell.showDateTime = _showDateTime;
        cell.article = article;
        
        return cell;
    }
    else {
        
        static NSString *kCustomCellID = @"NoDataCell";
        NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil)
        {
            cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCustomCellID];
        }
        
        cell.textLabel.text = text(@"没有数据");
//        cell.detailTextLabel.text = @"点击进行刷新";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_articles.count > 0) {
        
        Article *article = [_articles objectAtIndex:indexPath.row];
        
        if (_delegate && [_delegate respondsToSelector:@selector(tableSectionWidget:didClickedArticle:)])
            [_delegate tableSectionWidget:self didClickedArticle:article];
    }
}

@end

