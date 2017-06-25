//
//  MessageView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "MessageView.h"
#import "MessageAPI.h"
#import "Message.h"
#import "MessageCell.h"
#import "NoDataTableViewCell.h"
#import "MJRefreshComponent+Customize.h"
#import "JPUSHService.h"

@interface MessageView () {
    
    NSMutableArray *_messages;
    NSInteger _page;
}

@end

@implementation MessageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:K_SHOULD_RELOAD_DATA_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLanguageNotification:) name:K_DID_CHANGE_LANGUAGE_NOTIFICATION object:nil];
    
    navigationBarWidget.title = text(@"消息");
    navigationBarWidget.backButtonHidden = YES;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [MJRefreshComponent addCustomizeRefreshInScrollView:_messageTableView withHeaderRefreshBlock:^{
        
        [self reloadData];
    } withFooterRefreshBlock:^{
        
        [self more];
    }];
    
    _messages = [NSMutableArray new];
    
    [_messageTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).mainNavigationController = self.navigationController;
    [((MainTabBarController *) self.tabBarController) showNewTabBar];
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
    
    if ([User checkPermission]) {
        
        MessageAPI *messageAPI = [MessageAPI new];
        [messageAPI setSuccessBlock:^(id result) {
            
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *dataDictionary in result[@"data"]) {
                
                [array addObject:dataDictionary[@"data"]];
            }
            
            NSArray *messages = [Message arrayOfModelsFromDictionaries:array error:nil];
            BOOL noMoreData = result[@"next_page_url"] == [NSNull null];
            
            [_messageTableView.mj_header endRefreshing];
            [_messageTableView.mj_footer endRefreshing];
            
            if (_page <= 1) {
                [_messages removeAllObjects];
            }
            [_messages addObjectsFromArray:messages];
            
            [_messageTableView reloadData];
            
            [_messageTableView.mj_footer setHidden:noMoreData];
            
            if (messages.count < [result[@"per_page"] integerValue]) {
                [_messageTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        [messageAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
            
            [_messageTableView.mj_header endRefreshingWithCompletionBlock:^{
                
                [_messageTableView reloadData];
            }];
            [_messageTableView.mj_footer endRefreshing];
            
            [_messageTableView.mj_footer setHidden:YES];
        }];
        [messageAPI getMessagesWithPage:_page];
    }
    else {
        
        [_messages removeAllObjects];
        
        [_messageTableView.mj_header endRefreshingWithCompletionBlock:^{
            
            [_messageTableView reloadData];
        }];
        [_messageTableView.mj_footer endRefreshing];
        
        [_messageTableView.mj_footer setHidden:YES];
    }
}

#pragma mark UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_messages.count > 0)
        return _messages.count;
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
    
    if (_messages.count > 0) {
        
        Message *message = [_messages objectAtIndex:indexPath.row];
        return [MessageCell suggestHeightWithMessage:message];
    }
    else
        return tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_messages.count > 0) {
        
        NSString *identifier = @"MessageCell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            [cell setupSubviews];
        }
        
        Message *message = [_messages objectAtIndex:indexPath.row];
        cell.message = message;
        
        return cell;
    }
    else {
        
        static NSString *kCustomCellID = @"NoDataCell";
        NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil)
        {
            cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCustomCellID];
        }
        
        cell.textLabel.text = [_messageTableView.mj_header isRefreshing] ? text(@"正在加载数据") :text(@"没有消息");
        
        return cell;
    }
}

- (void)didChangeLanguageNotification:(NSNotification *)notification {
    
    navigationBarWidget.title = text(@"消息");
    [self reloadTableViewData];
}

@end
