//
//  DiscoveryView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "DiscoveryView.h"
#import "ArticleListView.h"

@interface DiscoveryView ()

@end

@implementation DiscoveryView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    navigationBarWidget.title = text(@"发现");
    navigationBarWidget.backButtonHidden = YES;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [_discoveryTableView reloadData];
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

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 1;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *loginCellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loginCellIdentifer];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:kFontSizeTitle];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"房山旅游文化"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = text(@"房山旅游文化");
        }
    }
    else {
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"每日一句学中文"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = text(@"每日一句学中文");
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            //房山旅游文化
            ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
            articleListView.columnId = 3;
            articleListView.title = text(@"房山旅游文化");
            [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
        }
    }
    else {
        
        if (indexPath.row == 0) {
            
        }
    }
}

@end
