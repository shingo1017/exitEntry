//
//  StayInfoView.m
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "StayInfoView.h"
#import "TextInfoTableCell.h"
#import "TextEditTableCell.h"
#import "ImageInfoTableCell.h"
#import "MutiImageInfoTableCell.h"
#import "BookAPI.h"
#import "BookInfo.h"
#import "Dictionary.h"
#import "HXPhotoViewController.h"
#import "UIImage+Additions.h"
#import "PhotoSampleView.h"

@interface StayInfoView () <HXPhotoViewControllerDelegate> {
    
    HXPhotoManager *_manager;
    NSArray *_imagesNeedUpload;
    NSMutableArray *_imageUrls;
    NSInteger _selectedIndex;
}

@end

@implementation StayInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BACKGROUND_COLOR;
    navigationBarWidget.title = text(@"住宿信息");
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"提交")];
    
//    policeStationPickerView.pickerView.dataSource = self;
//    policeStationPickerView.pickerView.delegate = self;
//    communityPickerView.pickerView.dataSource = self;
//    communityPickerView.pickerView.delegate = self;
    houseTypePickerView.pickerView.dataSource = self;
    houseTypePickerView.pickerView.delegate = self;
    landlordCountryPickerView.pickerView.dataSource = self;
    landlordCountryPickerView.pickerView.delegate = self;
    landlordGenderPickerView.pickerView.dataSource = self;
    landlordGenderPickerView.pickerView.delegate = self;

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

- (void)haveContractSwitched:(UISwitch *)haveContractSwitch {
    
    [BookInfo defaultBookInfo].haveContract = haveContractSwitch.isOn;
    
    [infoTableView reloadData];
}

//提交
- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget {
    
    NSString *errorMessage = [[BookInfo defaultBookInfo] stayInfoVerification];
    if (errorMessage.length > 0)
        [MBProgressHUD showError:errorMessage];
    else {
        
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
                
                [MAIN_NAVIGATIONCONTROLLER popToRootViewControllerAnimated:YES];
            }];
            [bookAPI submitInfo];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
        return 3;
    else if ([BookInfo defaultBookInfo].haveContract)
        return 3;
    else
        return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1 && [BookInfo defaultBookInfo].haveContract) {
        
        if (indexPath.row == 1)
            return 90.0f;
        else if (indexPath.row == 2)
            return 120.0f;
        else
            return 45.0f;
    }
    else
        return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *textInfoTableCellId = @"TextInfoTableCell";
    NSString *textEditTableCellId = @"TextEditTableCell";
    NSString *imageInfoTableCellId = @"ImageInfoTableCell";
    NSString *mutiImageInfoTableCellId = @"MutiImageInfoTableCell";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
        
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"拟离开日期");
            if ([BookInfo defaultBookInfo].checkOutDate)
                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].checkOutDate stringValue];
            else
                textInfoTableCell.valueLabel.text = text(@"拟离开日期占位符");
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].checkOutDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
        else if (indexPath.row == 1) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"详细地址");
            textEditTableCell.valueText.placeholder = text(@"详细地址占位符");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].houseAddress;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].houseAddress = text;
            }];
            return textEditTableCell;
        }
        else {
            
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"住房种类");
            if ([BookInfo defaultBookInfo].houseType.length > 0)
                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].houseType inDictionaries:[Dictionary houseTypeArray]];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].houseType.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
        
//        if (indexPath.row == 0) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"入住日期");
//            if ([BookInfo defaultBookInfo].checkInDate)
//                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].checkInDate stringValue];
//            else
//                textInfoTableCell.valueLabel.text = text(@"入住日期占位符");
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].checkInDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        else if (indexPath.row == 3) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"所属派出所");
//            if ([BookInfo defaultBookInfo].policeStation.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].policeStation inDictionaries:[Dictionary policeStationArray]];
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].policeStation.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        else if (indexPath.row == 4) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"所属社区");
//            if ([BookInfo defaultBookInfo].community.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].community inDictionaries:[Dictionary communityArrayWithPoliceStation:[BookInfo defaultBookInfo].policeStation]];
//            else
//                textInfoTableCell.valueLabel.text = text(@"未设置");
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].community.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
    }
    else {
        
        if (indexPath.row == 0) {
            
            static NSString *cellIdentifer = @"HaveContractCell";
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"我有房主身份证和房屋租赁合同");
            
            UISwitch *haveContractSwitch = [textInfoTableCell viewWithTag:10];
            if (!haveContractSwitch) {
                
                haveContractSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - 15, 7, 51, 31)];
                [textInfoTableCell addSubview:haveContractSwitch];
            }
            [haveContractSwitch addTarget:self action:@selector(haveContractSwitched:) forControlEvents:UIControlEventValueChanged];
            haveContractSwitch.tag = 10;
            haveContractSwitch.on = [BookInfo defaultBookInfo].haveContract;
            
            textInfoTableCell.captionLabel.width = SCREEN_WIDTH - textInfoTableCell.captionLabel.left - haveContractSwitch.width - 15;
            textInfoTableCell.valueLabel.hidden = YES;
            
            return textInfoTableCell;
        }
        if ([BookInfo defaultBookInfo].haveContract) {
            
            if (indexPath.row == 1) {
                
                ImageInfoTableCell *imageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:imageInfoTableCellId forIndexPath:indexPath];
                imageInfoTableCell.captionLabel.text = text(@"房主身份证照片");
                [imageInfoTableCell.valueImageView sd_setImageWithURL:[BookInfo defaultBookInfo].landlordIdentityPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
                imageInfoTableCell.imageSize = CGSizeMake(40, 60);
                return imageInfoTableCell;
            }
            else {
                
                MutiImageInfoTableCell *mutiImageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:mutiImageInfoTableCellId forIndexPath:indexPath];
                mutiImageInfoTableCell.captionLabel.text = text(@"房屋租赁合同照片");
                mutiImageInfoTableCell.valueLabel.text = [NSString stringWithFormat:@"%li%@", [BookInfo defaultBookInfo].houseRentalContractPhotos.count, text(@"张照片")];
                mutiImageInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].houseRentalContractPhotos.count > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
                [mutiImageInfoTableCell.valueCollectionView reloadData];
                return mutiImageInfoTableCell;
            }
        }
        else {
            
            
            if (indexPath.row == 2) {
                
                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
                textInfoTableCell.captionLabel.text = text(@"房主国家");
                if ([BookInfo defaultBookInfo].landlordCountry.length > 0)
                    textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].landlordCountry inDictionaries:[Dictionary countryArray]];
                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].landlordCountry.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
                return textInfoTableCell;
            }
            else if (indexPath.row == 3) {
                
                TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
                textEditTableCell.captionLabel.text = text(@"房主身份证号");
                textEditTableCell.valueText.text = [BookInfo defaultBookInfo].landlordIdentityNumber;
                [textEditTableCell setValueChangedBlock:^(NSString *text) {
                    
                    [BookInfo defaultBookInfo].landlordIdentityNumber = text;
                }];
                return textEditTableCell;
            }
            else if (indexPath.row == 4) {
                
                TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
                textEditTableCell.captionLabel.text = text(@"房主中文姓名");
                textEditTableCell.valueText.text = [BookInfo defaultBookInfo].landlordName;
                [textEditTableCell setValueChangedBlock:^(NSString *text) {
                    
                    [BookInfo defaultBookInfo].landlordName = text;
                }];
                return textEditTableCell;
            }
            else if (indexPath.row == 5) {
                
                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
                textInfoTableCell.captionLabel.text = text(@"房主性别");
                if ([BookInfo defaultBookInfo].landlordGender.length > 0)
                    textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].landlordGender inDictionaries:[Dictionary genderArray]];
                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].landlordGender.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
                return textInfoTableCell;
            }
            else {
                
                TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
                textEditTableCell.captionLabel.text = text(@"房主联系电话");
                textEditTableCell.valueText.text = [BookInfo defaultBookInfo].landlordPhoneNumber;
                textEditTableCell.valueText.keyboardType = UIKeyboardTypePhonePad;
                [textEditTableCell setValueChangedBlock:^(NSString *text) {
                    
                    [BookInfo defaultBookInfo].landlordPhoneNumber = text;
                }];
                return textEditTableCell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {

//        if (indexPath.row == 0)
//            [self showCheckInDatePickerView];
        if (indexPath.row == 0)
            [self showCheckOutDatePickerView];
        else if (indexPath.row == 2)
            [self showHouseTypePickerView];
//        else if (indexPath.row == 3)
//            [self showPoliceStationPickerView];
//        else if (indexPath.row == 4)
//            [self showCommunityPickerView];
    }
    else if (indexPath.section == 1) {
    
        if ([BookInfo defaultBookInfo].haveContract) {
            
            if (indexPath.row == 1) {
                
                //房主身份证照片
                [self showPhotoPickerView];
            }
        }
        else {
            
            if (indexPath.row == 2)
                [self showCountryPickerView];
            else if (indexPath.row == 5)
                [self showGenderPickerView];
        }
    }
}

#pragma mark Select Row Methods

- (void)hideAllPickerView {
    
//    [checkInDatePickerView hide];
    [checkOutPickerView hide];
//    [policeStationPickerView hide];
//    [communityPickerView hide];
    [houseTypePickerView hide];
    [landlordCountryPickerView hide];
    [landlordGenderPickerView hide];
}

- (void)showGenderPickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [landlordGenderPickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].landlordGender inDictionaries:[Dictionary genderArray]];
    if (index == NSNotFound) index = 0;
    [landlordGenderPickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

//- (void)showPoliceStationPickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [policeStationPickerView show];
//    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].policeStation inDictionaries:[Dictionary policeStationArray]];
//    if (index == NSNotFound) index = 0;
//    [policeStationPickerView.pickerView selectRow:index inComponent:0 animated:NO];
//}
//
//- (void)showCommunityPickerView {
//    
//    if ([BookInfo defaultBookInfo].policeStation.length == 0)
//        [MBProgressHUD showError:text(@"请先选择所属派出所")];
//    else {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//        
//        [self hideAllPickerView];
//        [communityPickerView show];
//        NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].community inDictionaries:[Dictionary communityArrayWithPoliceStation:[BookInfo defaultBookInfo].policeStation]];
//        if (index == NSNotFound) index = 0;
//        [communityPickerView.pickerView selectRow:index inComponent:0 animated:NO];
//    }
//}

- (void)showHouseTypePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [houseTypePickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].houseType inDictionaries:[Dictionary houseTypeArray]];
    if (index == NSNotFound) index = 0;
    [houseTypePickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)showCountryPickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [landlordCountryPickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].landlordCountry inDictionaries:[Dictionary countryArray]];
    if (index == NSNotFound) index = 0;
    [landlordCountryPickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

//- (void)showCheckInDatePickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [checkInDatePickerView show];
//    if ([BookInfo defaultBookInfo].checkInDate)
//        [checkInDatePickerView.datePickerView setDate:[BookInfo defaultBookInfo].checkInDate animated:NO];
//    else
//        [checkInDatePickerView.datePickerView setDate:[NSDate date] animated:NO];
//}

- (void)showCheckOutDatePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [checkOutPickerView show];
    if ([BookInfo defaultBookInfo].checkOutDate)
        [checkOutPickerView.datePickerView setDate:[BookInfo defaultBookInfo].checkOutDate animated:NO];
    else
        [checkOutPickerView.datePickerView setDate:[NSDate date] animated:NO];
}

- (void)showPhotoPickerView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"请选择...") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:text(@"从照片库选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            
            [MBProgressHUD showError:text(@"设备不支持照片库功能")];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:imagepicker animated:YES completion:nil];
        } else {
            
            [MBProgressHUD showError:text(@"设备不支持拍照功能")];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
//    if (pickerView == policeStationPickerView.pickerView)
//        return [Dictionary policeStationArray].count;
//    else if (pickerView == communityPickerView.pickerView)
//        return [Dictionary communityArrayWithPoliceStation:[BookInfo defaultBookInfo].policeStation].count;
    if (pickerView == houseTypePickerView.pickerView)
        return [Dictionary houseTypeArray].count;
    else if (pickerView == landlordCountryPickerView.pickerView)
        return [Dictionary countryArray].count;
    else
        return [Dictionary genderArray].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
//    if (pickerView == policeStationPickerView.pickerView)
//        return ((Dictionary *)[Dictionary policeStationArray][row]).text;
//    else if (pickerView == communityPickerView.pickerView)
//        return ((Dictionary *)[Dictionary communityArrayWithPoliceStation:[BookInfo defaultBookInfo].policeStation][row]).text;
    if (pickerView == houseTypePickerView.pickerView)
        return ((Dictionary *)[Dictionary houseTypeArray][row]).text;
    else if (pickerView == landlordCountryPickerView.pickerView)
        return ((Dictionary *)[Dictionary countryArray][row]).text;
    else
        return ((Dictionary *)[Dictionary genderArray][row]).text;
}

- (void)didClickedDoneButton:(PickerWidget *)pickerWidget {
    
    NSInteger row = [pickerWidget.pickerView selectedRowInComponent:0];
    
//    if (pickerWidget == policeStationPickerView) {
//        
//        [BookInfo defaultBookInfo].policeStation = ((Dictionary *)[Dictionary policeStationArray][row]).value;
//        [BookInfo defaultBookInfo].community = @"";
//        [communityPickerView.pickerView reloadAllComponents];
//    }
//    else if (pickerWidget == communityPickerView)
//        [BookInfo defaultBookInfo].community = ((Dictionary *)[Dictionary communityArrayWithPoliceStation:[BookInfo defaultBookInfo].policeStation][row]).value;
    if (pickerWidget == houseTypePickerView)
        [BookInfo defaultBookInfo].houseType = ((Dictionary *)[Dictionary houseTypeArray][row]).value;
    else if (pickerWidget == landlordCountryPickerView)
        [BookInfo defaultBookInfo].landlordCountry = ((Dictionary *)[Dictionary countryArray][row]).value;
    else if (pickerWidget == landlordGenderPickerView)
        [BookInfo defaultBookInfo].landlordGender = ((Dictionary *)[Dictionary genderArray][row]).value;
    
    [self fillData];
}

- (void)didClickedDateDoneButton:(DatePickerWidget *)datePickerWidget {
    
//    if (datePickerWidget == checkInDatePickerView) {
//        
//        [BookInfo defaultBookInfo].checkInDate = datePickerWidget.datePickerView.date;
//    }
    if (datePickerWidget == checkOutPickerView) {
        
        [BookInfo defaultBookInfo].checkOutDate = datePickerWidget.datePickerView.date;
    }
    
    [self fillData];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [BookInfo defaultBookInfo].houseRentalContractPhotos.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(40, 60);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"AddCollectionCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell borderStyleWithColor:BORDER_COLOR];
        return cell;
    }
    else {
        
        static NSString *identifier = @"ValueCollectionCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        UIImageView *imageView = [cell viewWithTag:10];
        [imageView sd_setImageWithURL:[BookInfo defaultBookInfo].houseRentalContractPhotos[indexPath.row - 1]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
        vc.delegate = self;
        vc.manager = self.manager;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"确定要删除这张照片吗？") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"删除") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            _imageUrls = [[NSMutableArray alloc] initWithArray:[BookInfo defaultBookInfo].houseRentalContractPhotos];
            [_imageUrls removeObjectAtIndex:indexPath.row - 1];
            [BookInfo defaultBookInfo].houseRentalContractPhotos = _imageUrls;
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:text(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate method  //单选

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image scaleToSizeWithWidth:400];
        [self uploadlandlordIdentityCardPhoto:image];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadlandlordIdentityCardPhoto:(UIImage *)photo {
    
    if (nil == photo) {
        return;
    }
    [MBProgressHUD showMessage:text(@"上传照片中")];
    
    @weakify(self)
    BookAPI *bookAPI = [BookAPI new];
    [bookAPI setSuccessBlock:^(id result) {
        
        @strongify(self)
        NSLog(@"result = %@", result);
        if (nil == result[@"url"]) {
            return;
        }
        
        [MBProgressHUD hideHUDs];
        [BookInfo defaultBookInfo].landlordIdentityPhotoUrl = [NSURL URLWithString:result[@"url"]];
        [[BookInfo defaultBookInfo] save];
        
        [self->infoTableView reloadData];
    }];
    [bookAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
        
        [MBProgressHUD showError:errorReason];
    }];
    [bookAPI uploadPhoto:photo];
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    return _manager;
}

- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original {
    
    [HXPhotoTools fetchHDImageForSelectedPhoto:photos completion:^(NSArray<UIImage *> *images) {
        
        _selectedIndex = 0;
        _imagesNeedUpload = [[NSMutableArray alloc] initWithArray:images];
        _imageUrls = [NSMutableArray new];
        
        [self uploadImage];
    }];
}

// 点击取消
- (void)photoViewControllerDidCancel {
    
    
}

- (void)uploadImage {
    
    UIImage *image = _imagesNeedUpload[_selectedIndex];
    
    [MBProgressHUD hideHUDs];
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"正在上传第%zi张照片", _selectedIndex + 1]];
    
    @weakify(self)
    BookAPI *bookAPI = [BookAPI new];
    [bookAPI setSuccessBlock:^(id result) {
        
        @strongify(self)
        
        [_imageUrls addObject:result[@"url"]];
        
        if (_imageUrls.count == _imagesNeedUpload.count) {
            
            //全部上传完毕
            [MBProgressHUD hideHUDs];
            
            [BookInfo defaultBookInfo].houseRentalContractPhotos = _imageUrls;
            [[BookInfo defaultBookInfo] save];
            
            [infoTableView reloadData];
        }
        else {
            
            _selectedIndex += 1;
            [self uploadImage];
        }
    }];
    [bookAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
        
        [MBProgressHUD showError:errorReason];
    }];
    [bookAPI uploadPhoto:image];
}

@end
