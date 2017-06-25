//
//  MyView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "MyView.h"
#import "LoginAPI.h"
#import "BookView.h"
#import "FeedbackView.h"
#import "AboutView.h"
#import "BookInfo.h"
#import "CertificateView.h"
#import "WriteOffInfoView.h"

@interface MyView () {
    
    NSArray *_images;
    NSArray *_titles;
}

@end

@implementation MyView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadMyViewNotification:) name:K_DID_LOGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadMyViewNotification:) name:K_SHOULD_RELOAD_STATUS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLanguageNotification:) name:K_DID_CHANGE_LANGUAGE_NOTIFICATION object:nil];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
//    navigationBarWidget.title = text(@"我的");
//    navigationBarWidget.backButtonHidden = YES;
    
    [userImageView roundStyle];
    myHeaderView.backgroundColor = [UIColor whiteColor];
    [logoutButton setTitle:text(@"退出登录") forState:UIControlStateNormal];
    [logoutButton cornerRadiusStyle];
    logoutButton.backgroundColor = MAIN_COLOR;
    
    languagePickerWidget.pickerView.dataSource = self;
    languagePickerWidget.pickerView.delegate = self;
    
    _images = @[@"setting", @"setting", @"setting", @"setting", @"setting", @"setting"];
    _titles = @[text(@"注册登记资料"), text(@"信息核销"), text(@"电子证书"), text(@"语言设置"), text(@"用户反馈"), text(@"关于我们")];
    
    myTableView.tableHeaderView = myHeaderView;
    myTableView.tableFooterView = myFooterView;
    
    [self fillData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).mainNavigationController = self.navigationController;
    [((MainTabBarController *) self.tabBarController) showNewTabBar];
    
    [self fillData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    
    if (NETWORK)
        [self stopLoading];
}

- (void)fillData {
    
    [userImageView sd_setImageWithURL:[BookInfo defaultBookInfo].myPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
    
//    if ([User isLogin]) {
    
        nicknameLabel.textColor = [UIColor whiteColor];
        nicknameLabel.font = [UIFont systemFontOfSize:14.0f];
        nicknameLabel.text = [NSString stringWithFormat:@"%@ （%@）", [User defaultUser].name, [User defaultUser].bookStatusText];
//    }
//    else {
//        
//        nicknameLabel.textColor = SUMMARY_COLOR;
//        nicknameLabel.font = [UIFont systemFontOfSize:12.0f];
//        nicknameLabel.text = @"点击这里进行注册/登录";
//    }
    
    [myTableView reloadData];
    
    logoutButton.hidden = ![User isLogin];
}

- (IBAction)headerButtonClicked:(id)sender {
    
    if ([User checkPermission]) {
        
        //MyInfoView *myInfoView = [UIStoryboard viewControllerWithName:@"MyInfoView"];
        //[self.navigationController pushViewController:myInfoView animated:YES];
    }
}

- (IBAction)logoutButtonClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"提示") message:text(@"确定要退出当前账号吗？") preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"退出") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [User setDefaultUser:nil];
        [BookInfo setDefaultBookInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_DID_LOGIN_NOTIFICATION object:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shouldReloadMyViewNotification:(NSNotification *)notification {
    
    [self fillData];
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titles.count;
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
    
    static NSString *kCustomCellID = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        //注册登记资料
        if ([User defaultUser].bookStatus == BookStatusNotSubmit || [User defaultUser].bookStatus == BookStatusRejected) {
            
            if ([User checkPermission]) {
                
                //登记注册
                BookView *bookView = [self.storyboard instantiateViewControllerWithIdentifier:@"BookView"];
                [MAIN_NAVIGATIONCONTROLLER pushViewController:bookView animated:YES];
            }
        }
        else if ([User defaultUser].bookStatus == BookStatusCertificateReady) {
            
            CertificateView *certificateView = [self.storyboard instantiateViewControllerWithIdentifier:@"CertificateView"];
            [MAIN_NAVIGATIONCONTROLLER pushViewController:certificateView animated:YES];
        }
    }
    else if (indexPath.row == 1) {
        
        //核销信息
        if ([User defaultUser].bookStatus == BookStatusCertificateReady) {
            
            WriteOffInfoView *writeOffInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteOffInfoView"];
            [MAIN_NAVIGATIONCONTROLLER pushViewController:writeOffInfoView animated:YES];
        }
        else
            [MBProgressHUD showError:text(@"当前状态不可核销")];
    }
    else if (indexPath.row == 2) {
        
        //下载电子证书
        if ([User defaultUser].bookStatus == BookStatusCertificateReady) {
            
            CertificateView *certificateView = [self.storyboard instantiateViewControllerWithIdentifier:@"CertificateView"];
            [MAIN_NAVIGATIONCONTROLLER pushViewController:certificateView animated:YES];
        }
        else
            [MBProgressHUD showError:text(@"电子证书还没有准备完毕")];
    }
    else if (indexPath.row == 3) {
        
        //语言设置
        [languagePickerWidget show];
        NSInteger index = [Dictionary indexForValue:((AppDelegate *)[UIApplication sharedApplication].delegate).language inDictionaries:[Dictionary languageArray]];
        if (index == NSNotFound) index = 0;
        [languagePickerWidget.pickerView selectRow:index inComponent:0 animated:NO];
    }
    else if (indexPath.row == 4) {
        
        //用户反馈
        if ([User checkPermission]) {
        
            FeedbackView *feedbackView = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackView"];
            feedbackView.title = text(@"用户反馈");
            [MAIN_NAVIGATIONCONTROLLER pushViewController:feedbackView animated:YES];
        }
    }
    else if (indexPath.row == 5) {
        
        //关于
        AboutView *aboutView = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:aboutView animated:YES];
    }
}

#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [Dictionary languageArray].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return ((Dictionary *)[Dictionary languageArray][row]).text;
}

- (void)didClickedDoneButton:(PickerWidget *)pickerWidget {
    
    NSInteger row = [pickerWidget.pickerView selectedRowInComponent:0];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).language = ((Dictionary *)[Dictionary languageArray][row]).value;
    [[NSUserDefaults standardUserDefaults] setObject:((AppDelegate *)[UIApplication sharedApplication].delegate).language forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_DID_CHANGE_LANGUAGE_NOTIFICATION object:nil];
}

- (void)didChangeLanguageNotification:(NSNotification *)notification {
    
    nicknameLabel.text = [NSString stringWithFormat:@"%@ （%@）", [User defaultUser].name, [User defaultUser].bookStatusText];
    _titles = @[text(@"注册登记资料"), text(@"信息核销"), text(@"电子证书"), text(@"语言设置"), text(@"用户反馈"), text(@"关于我们")];
    [logoutButton setTitle:text(@"退出登录") forState:UIControlStateNormal];
    [myTableView reloadData];
}

@end
