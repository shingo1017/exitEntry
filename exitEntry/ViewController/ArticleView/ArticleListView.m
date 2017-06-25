//
//  ArticleListView.m
//  exitEntry
//
//  Created by 尹楠 on 17/4/6.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "ArticleListView.h"
#import "ArticleAPI.h"
#import "ArticleDetailView.h"
#import "TableSectionCell.h"
#import "NoDataTableViewCell.h"
#import "MJRefreshComponent+Customize.h"

@interface ArticleListView () {
    
    NSMutableArray *_articles;
    NSInteger _page;
}

@end

@implementation ArticleListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navigationBarWidget.title = self.title;
    
    [MJRefreshComponent addCustomizeRefreshInScrollView:articleTableView withHeaderRefreshBlock:^{
        
        [self reloadData];
    } withFooterRefreshBlock:^{
        
        [self more];
    }];
    
    _articles = [NSMutableArray new];
    
    [articleTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    
    _page = 1;
    
    [self reloadTableViewData];
}

- (void)more {
    
    _page += 1;
    
    [self reloadTableViewData];
}

- (void)reloadTableViewData {
    
    ArticleAPI *articleAPI = [ArticleAPI new];
    [articleAPI setSuccessBlock:^(id result) {
        
        NSArray *articles = [Article arrayOfModelsFromDictionaries:result[@"data"] error:nil];
        BOOL noMoreData = result[@"next_page_url"] == [NSNull null];
        
        [articleTableView.mj_header endRefreshing];
        [articleTableView.mj_footer endRefreshing];
        
        if (_page <= 1) {
            [_articles removeAllObjects];
        }
        [_articles addObjectsFromArray:articles];
        
        [articleTableView reloadData];
        
        [articleTableView.mj_footer setHidden:noMoreData];
        
        if (articles.count < [result[@"per_page"] integerValue]) {
            [articleTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [articleTableView reloadData];
    }];
    [articleAPI getArticlesWithColumnId:self.columnId page:_page];
}

- (BOOL)showDateTime {
    
    if (_columnId == 1 || _columnId == 3 || _columnId == 5)
        return NO;
    else
        return YES;
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
        CGFloat rowHeight = [TableSectionCell suggestHeightWithArticle:article showDateTime:self.showDateTime];
        return rowHeight;
    }
    else
        return tableView.height;
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
        cell.showDateTime = self.showDateTime;
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
        
        cell.textLabel.text = [articleTableView.mj_header isRefreshing] ? text(@"正在加载数据") :text(@"没有数据");
        //        cell.detailTextLabel.text = @"点击进行刷新";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_articles.count > 0) {
        
        Article *article = [_articles objectAtIndex:indexPath.row];
        
        ArticleDetailView *articleDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailView"];
        articleDetailView.showDateTime = self.showDateTime;
        articleDetailView.title = article.title;
        articleDetailView.article = article;
        [MAIN_NAVIGATIONCONTROLLER pushViewController:articleDetailView animated:YES];
    }
}

@end
