//
//  WriteOffInfoView.m
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "WriteOffInfoView.h"
#import "TextInfoTableCell.h"
#import "TextEditTableCell.h"
#import "BookAPI.h"
#import "BookInfo.h"
#import "Dictionary.h"

@interface WriteOffInfoView ()

@end

@implementation WriteOffInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BACKGROUND_COLOR;
    navigationBarWidget.title = text(@"信息核销");
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"提交")];

    [self fillData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
}

- (void)fillData {

    [infoTableView reloadData];
}

#pragma mark NavigationBarWidgetDelegate method

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    [[BookInfo defaultBookInfo] save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget {
    
    NSString *errorMessage = [[BookInfo defaultBookInfo] writeOffVerification];
    if (errorMessage.length > 0)
        [MBProgressHUD showError:errorMessage];
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"警告") message:text(@"警告确认核销") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"确认核销") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showMessage:text(@"正在提交，请稍后")];
            BookAPI *bookAPI = [BookAPI new];
            [bookAPI setSuccessBlock:^(id result) {
                
                [BookInfo setDefaultBookInfo:nil];
                [User defaultUser].bookStatus = BookStatusNotSubmit;
                
                [MBProgressHUD showSuccess:text(@"信息核销成功")];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_RELOAD_STATUS_NOTIFICATION object:nil];
                
                [MAIN_NAVIGATIONCONTROLLER popViewControllerAnimated:YES];
            }];
            [bookAPI writeOffInfo];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *textInfoTableCellId = @"TextInfoTableCell";
    NSString *textEditTableCellId = @"TextEditTableCell";

    if (indexPath.row == 0) {
        
        TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
        textInfoTableCell.captionLabel.text = text(@"离开日期");
        if ([BookInfo defaultBookInfo].leaveCountryDate)
            textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].leaveCountryDate stringValue];
        textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].leaveCountryDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
        return textInfoTableCell;
    }
    else if (indexPath.row == 1) {
        
        TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
        textEditTableCell.captionLabel.text = text(@"离开原因");
        textEditTableCell.valueText.text = [BookInfo defaultBookInfo].leaveReason;
        [textEditTableCell setValueChangedBlock:^(NSString *text) {
            
            [BookInfo defaultBookInfo].leaveReason = text;
        }];
        return textEditTableCell;
    }
    else {
        
        TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
        textEditTableCell.captionLabel.text = text(@"去往目的地");
        textEditTableCell.valueText.text = [BookInfo defaultBookInfo].whereToGo;
        [textEditTableCell setValueChangedBlock:^(NSString *text) {
            
            [BookInfo defaultBookInfo].whereToGo = text;
        }];
        return textEditTableCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0)
        [self showLeaveCountryDatePickerView];
}

#pragma mark Select Row Methods

- (void)hideAllPickerView {
    
    [leaveCountryPickerView hide];
}

- (void)showLeaveCountryDatePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [leaveCountryPickerView show];
    if ([BookInfo defaultBookInfo].leaveCountryDate)
        [leaveCountryPickerView.datePickerView setDate:[BookInfo defaultBookInfo].leaveCountryDate animated:NO];
    else
        [leaveCountryPickerView.datePickerView setDate:[NSDate date] animated:NO];
}

#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (void)didClickedDateDoneButton:(DatePickerWidget *)datePickerWidget {
    
    [BookInfo defaultBookInfo].leaveCountryDate = datePickerWidget.datePickerView.date;
    
    [self fillData];
}

@end
