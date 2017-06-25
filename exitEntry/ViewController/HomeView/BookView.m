//
//  BookView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/28.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "BookView.h"
#import "BookInfo.h"
#import "BaseInfoView.h"
#import "VisaInfoView.h"
#import "StayInfoView.h"
#import "BookAPI.h"
#import "UIImage+Additions.h"

@interface BookView ()

@end

@implementation BookView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    navigationBarWidget.title = text(@"境外人员办理注册登记");
    
    [submitButton setTitle:text(@"提交登记注册资料") forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageWithColor:PLACEHOLDER_COLOR] forState:UIControlStateDisabled];
    [submitButton cornerRadiusStyle];
    
    bookTableView.tableFooterView = footerView;
    
    [self fillData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([User defaultUser].bookStatus == BookStatusRejected) {
        
        rejectReasonLabel.textColor = [UIColor whiteColor];
        rejectReasonLabel.text = [BookInfo defaultBookInfo].rejectReason;
        rejectReasonLabel.attributedText = [rejectReasonLabel.text attributedStringWithFontSize:rejectReasonLabel.font.pointSize textColor:rejectReasonLabel.textColor];
        rejectReasonLabel.height = [rejectReasonLabel.text heightOfAttributedText:rejectReasonLabel.attributedText width:rejectReasonLabel.width];
        
        headerView.backgroundColor = rgba(245, 64, 64, 1);
        headerView.height = rejectReasonLabel.height + 30;
        bookTableView.tableHeaderView = headerView;
    }
    else
        bookTableView.tableHeaderView = nil;
    [bookTableView reloadData];
    [self fillData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillData {
    
    if (([User defaultUser].bookStatus == BookStatusNotSubmit || [User defaultUser].bookStatus == BookStatusRejected) && [[BookInfo defaultBookInfo] baseInfoVerification].length == 0 && [[BookInfo defaultBookInfo] visaInfoVerification].length == 0 && [[BookInfo defaultBookInfo] stayInfoVerification].length == 0)
        submitButton.enabled = YES;
    else
        submitButton.enabled = NO;
}

- (IBAction)submitButtonClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"提示") message:text(@"确定要提交登记资料吗？") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"提交") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD showMessage:text(@"正在提交，请稍后")];
        BookAPI *bookAPI = [BookAPI new];
        [bookAPI setSuccessBlock:^(id result) {
            
            [[BookInfo defaultBookInfo] save];
            
            [User defaultUser].bookStatus = BookStatusWatingForReview;
            
            if ([result isKindOfClass:NSDictionary.class])
                SET_INFO_ID(result[@"id"]);
            
            [MBProgressHUD showSuccess:text(@"资料已经成功提交")];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_RELOAD_STATUS_NOTIFICATION object:nil];
            
            [MAIN_NAVIGATIONCONTROLLER popViewControllerAnimated:YES];
        }];
        [bookAPI submitInfo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *loginCellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loginCellIdentifer];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:kFontSizeTitle];
    if (indexPath.section == 0) {
        
        //            cell.imageView.image = [UIImage imageNamed:@"护照信息"];
        NSString *errorMessage = [[BookInfo defaultBookInfo] baseInfoVerification];
        cell.textLabel.attributedText = [self attributedStringWithTitle:text(@"基本信息") finished:errorMessage.length == 0];
    }
    else if (indexPath.section == 1) {
        
        //            cell.imageView.image = [UIImage imageNamed:@"护照信息"];
        NSString *errorMessage = [[BookInfo defaultBookInfo] visaInfoVerification];
        cell.textLabel.attributedText = [self attributedStringWithTitle:text(@"入境及签证（注）信息") finished:errorMessage.length == 0];
    }
    else {
        
//        cell.imageView.image = [UIImage imageNamed:@"每日一句学中文"];
        NSString *errorMessage = [[BookInfo defaultBookInfo] stayInfoVerification];
        cell.textLabel.attributedText = [self attributedStringWithTitle:text(@"住宿信息") finished:errorMessage.length == 0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        BaseInfoView *baseInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseInfoView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:baseInfoView animated:YES];
    }
    else if (indexPath.section == 1) {
        
        VisaInfoView *visaInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"VisaInfoView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:visaInfoView animated:YES];
    }
    else {
        
        StayInfoView *stayInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"StayInfoView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:stayInfoView animated:YES];
    }
}

- (NSAttributedString *)attributedStringWithTitle:(NSString *)title finished:(BOOL)finished {
    
    NSAttributedString *titleAttributedString;
    if (finished) {
        
        NSString *fullTitle = [NSString stringWithFormat:@"%@（%@）", title, text(@"填写完毕")];
        titleAttributedString = [fullTitle highlightColor:rgba(20, 220, 20, 1) betweenIndex:title.length andIndex:0];
    }
    else {
        
        NSString *fullTitle = [NSString stringWithFormat:@"%@（%@）", title, text(@"尚未填写完毕")];
        titleAttributedString = [fullTitle highlightColor:rgba(220, 20, 20, 1) betweenIndex:title.length andIndex:0];
    }
    return titleAttributedString;
}

- (void)dealloc {
    
    NSLog(@"dealloc");
}

@end
