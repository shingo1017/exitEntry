//
//  MyInfoView.m
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "BaseInfoView.h"
#import "TextInfoTableCell.h"
#import "TextEditTableCell.h"
#import "ImageInfoTableCell.h"
#import "BookAPI.h"
#import "BookInfo.h"
#import "Dictionary.h"
#import "VisaInfoView.h"
#import "UIImage+Additions.h"
#import "PhotoSampleView.h"

@interface BaseInfoView () {

    UIImage *_image;
    NSInteger _selectedIndex;
}

@end

@implementation BaseInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BACKGROUND_COLOR;
    navigationBarWidget.title = text(@"基本信息");
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"下一张表")];
    
    countryPickerView.pickerView.dataSource = self;
    countryPickerView.pickerView.delegate = self;
    identityTypePickerView.pickerView.dataSource = self;
    identityTypePickerView.pickerView.delegate = self;
//    personTypePickerView.pickerView.dataSource = self;
//    personTypePickerView.pickerView.delegate = self;
//    personAreaTypePickerView.pickerView.dataSource = self;
//    personAreaTypePickerView.pickerView.delegate = self;
//    genderPickerView.pickerView.dataSource = self;
//    genderPickerView.pickerView.delegate = self;
    occupationPickerView.pickerView.dataSource = self;
    occupationPickerView.pickerView.delegate = self;

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

#pragma mark - Network

- (void)_uploadImage:(UIImage *)image {
    
    if (nil == image) {
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
        if (_selectedIndex == 0)
            [BookInfo defaultBookInfo].myPhotoUrl = [NSURL URLWithString:result[@"url"]];
        else
            [BookInfo defaultBookInfo].passportPhotoUrl = [NSURL URLWithString:result[@"url"]];
        [[BookInfo defaultBookInfo] save];
        
        [self->infoTableView reloadData];
    }];
    [bookAPI setFailBlock:^(NSInteger errorCode, NSString *errorReason) {
        
        [MBProgressHUD showError:errorReason];
    }];
    [bookAPI uploadPhoto:image];
}

#pragma mark NavigationBarWidgetDelegate method

- (void)didClickedBackButton:(NavigationBarWidget *)navigationBarWidget {
    
    [[BookInfo defaultBookInfo] save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//点击下一张表
- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget {
    
    NSString *errorMessage = [[BookInfo defaultBookInfo] baseInfoVerification];
    if (errorMessage.length > 0)
        [MBProgressHUD showError:errorMessage];
    else {
        
        VisaInfoView *visaInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"VisaInfoView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:visaInfoView animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate method  //单选

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {

        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image scaleToSizeWithWidth:400];
        [self _uploadImage:image];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
        return 2;
    else if (section == 1)
        return 4;
    else
        return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0)
        return 90;
    else
        return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *textInfoTableCellId = @"TextInfoTableCell";
    NSString *textEditTableCellId = @"TextEditTableCell";
    NSString *imageInfoTableCellId = @"ImageInfoTableCell";

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
        
            ImageInfoTableCell *imageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:imageInfoTableCellId forIndexPath:indexPath];
            imageInfoTableCell.captionLabel.text = text(@"本人照片");
            [imageInfoTableCell.valueImageView sd_setImageWithURL:[BookInfo defaultBookInfo].myPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
            imageInfoTableCell.imageSize = CGSizeMake(40, 60);
            return imageInfoTableCell;
        }
        else {
            
            ImageInfoTableCell *imageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:imageInfoTableCellId forIndexPath:indexPath];
            imageInfoTableCell.captionLabel.text = text(@"护照照片");
            [imageInfoTableCell.valueImageView sd_setImageWithURL:[BookInfo defaultBookInfo].passportPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
            imageInfoTableCell.imageSize = CGSizeMake(40, 60);
            return imageInfoTableCell;
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"国家");
            if ([BookInfo defaultBookInfo].country.length > 0)
                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].country inDictionaries:[Dictionary countryArray]];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].country.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
        else if (indexPath.row == 1) {
            
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"证件类型");
            if ([BookInfo defaultBookInfo].identityType.length > 0)
                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].identityType inDictionaries:[Dictionary identityTypeArray]];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].identityType.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
        else if (indexPath.row == 2) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"证件号码");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].identityNumber;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            textEditTableCell.alwaysUppercase = YES;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].identityNumber = text;
            }];
            return textEditTableCell;
        }
        else {
            
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"证件有效期");
            if ([BookInfo defaultBookInfo].identityExpireDate)
                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].identityExpireDate stringValue];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].identityExpireDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
    }
    else {
        
//        if (indexPath.row == 0) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"人员类型");
//            if ([BookInfo defaultBookInfo].personType.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].personType inDictionaries:[Dictionary personTypeArray]];
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].personType.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        if (indexPath.row == 0) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"人员地域类型");
//            if ([BookInfo defaultBookInfo].personAreaType.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].personAreaType inDictionaries:[Dictionary personAreaTypeArray]];
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].personAreaType.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
        if (indexPath.row == 0) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"英文姓");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].englishLastName;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            textEditTableCell.alwaysUppercase = YES;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].englishLastName = text;
            }];
            return textEditTableCell;
        }
        else if (indexPath.row == 1) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"英文名");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].englishFirstName;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            textEditTableCell.alwaysUppercase = YES;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].englishFirstName = text;
            }];
            return textEditTableCell;
        }
        else if (indexPath.row == 2) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"中文名");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].name;
            textEditTableCell.valueText.placeholder = text(@"中文名占位符");
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].name = text;
            }];
            return textEditTableCell;
        }
//        else if (indexPath.row == 3) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"性别");
//            if ([BookInfo defaultBookInfo].gender.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].gender inDictionaries:[Dictionary genderArray]];
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].gender.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        else if (indexPath.row == 4) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"出生日期");
//            if ([BookInfo defaultBookInfo].birthday)
//                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].birthday stringValue];
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].birthday ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
        else if (indexPath.row == 3) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"出生地");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].homeplace;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].homeplace = text;
            }];
            return textEditTableCell;
        }
        else if (indexPath.row == 4) {
            
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"职业");
            if ([BookInfo defaultBookInfo].occupation.length > 0)
                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].occupation inDictionaries:[Dictionary occupationArray]];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].occupation.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
        }
        else if (indexPath.row == 5) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"工作机构");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].workingOrganization;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].workingOrganization = text;
            }];
            return textEditTableCell;
        }
        else if (indexPath.row == 6) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"本人联系电话");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].phoneNumber;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypePhonePad;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].phoneNumber = text;
            }];
            return textEditTableCell;
        }
        else if (indexPath.row == 7) {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"紧急联系人姓名");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].emergencyContact;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypeDefault;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].emergencyContact = text;
            }];
            return textEditTableCell;
        }
        else {
            
            TextEditTableCell *textEditTableCell = [tableView dequeueReusableCellWithIdentifier:textEditTableCellId forIndexPath:indexPath];
            textEditTableCell.captionLabel.text = text(@"紧急联系人的联系电话");
            textEditTableCell.valueText.text = [BookInfo defaultBookInfo].emergencyContactPhoneNumber;
            textEditTableCell.valueText.keyboardType = UIKeyboardTypePhonePad;
            [textEditTableCell setValueChangedBlock:^(NSString *text) {
                
                [BookInfo defaultBookInfo].emergencyContactPhoneNumber = text;
            }];
            return textEditTableCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        
        _selectedIndex = indexPath.row;
        [self showPhotoPickerView];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0)
            [self showCountryPickerView];
        else if (indexPath.row == 1)
            [self showIdentityTypePickerView];
        else if (indexPath.row == 3)
            [self showIdentityExpireDatePickerView];
    }
    else {

//        if (indexPath.row == 0)
//            [self showPersonTypePickerView];
//        if (indexPath.row == 0)
//            [self showPersonAreaTypePickerView];
//        if (indexPath.row == 3)
//            [self showGenderPickerView];
//        else if (indexPath.row == 4)
//            [self showBirthdayPickerView];
        if (indexPath.row == 4)
            [self showOccupationPickerView];
    }
}

#pragma mark Select Row Methods

- (void)showPhotoPickerView {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"请选择...") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (_selectedIndex == 1) {
        
        [alert addAction:[UIAlertAction actionWithTitle:text(@"标准照片示例") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
            
            PhotoSampleView *photoSampleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSampleView"];
            photoSampleView.photoName = @"证件信息页照片示例";
            [MAIN_NAVIGATIONCONTROLLER pushViewController:photoSampleView animated:YES];
        }]];
    }
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

- (void)hideAllPickerView {
    
    [countryPickerView hide];
    [identityTypePickerView hide];
    [identityExpireDatePickerView hide];
//    [personTypePickerView hide];
//    [personAreaTypePickerView hide];
//    [genderPickerView hide];
    [occupationPickerView hide];
//    [birthdayPickerView hide];
}

- (void)showCountryPickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [countryPickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].country inDictionaries:[Dictionary countryArray]];
    if (index == NSNotFound) index = 0;
    [countryPickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)showIdentityTypePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [identityTypePickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].identityType inDictionaries:[Dictionary identityTypeArray]];
    if (index == NSNotFound) index = 0;
    [identityTypePickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)showIdentityExpireDatePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [identityExpireDatePickerView show];
    if ([BookInfo defaultBookInfo].identityExpireDate)
        [identityExpireDatePickerView.datePickerView setDate:[BookInfo defaultBookInfo].identityExpireDate animated:NO];
    else
        [identityExpireDatePickerView.datePickerView setDate:[NSDate date] animated:NO];
}

//- (void)showPersonTypePickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [personTypePickerView show];
//    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].personType inDictionaries:[Dictionary personTypeArray]];
//    if (index == NSNotFound) index = 0;
//    [personTypePickerView.pickerView selectRow:index inComponent:0 animated:NO];
//}

//- (void)showPersonAreaTypePickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [personAreaTypePickerView show];
//    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].personAreaType inDictionaries:[Dictionary personAreaTypeArray]];
//    if (index == NSNotFound) index = 0;
//    [personAreaTypePickerView.pickerView selectRow:index inComponent:0 animated:NO];
//}

//- (void)showGenderPickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [genderPickerView show];
//    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].gender inDictionaries:[Dictionary genderArray]];
//    if (index == NSNotFound) index = 0;
//    [genderPickerView.pickerView selectRow:index inComponent:0 animated:NO];
//}
//
//- (void)showBirthdayPickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [birthdayPickerView show];
//    if ([BookInfo defaultBookInfo].birthday)
//        [birthdayPickerView.datePickerView setDate:[BookInfo defaultBookInfo].birthday animated:NO];
//    else
//        [birthdayPickerView.datePickerView setDate:[NSDate date] animated:NO];
//}

- (void)showOccupationPickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [occupationPickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].occupation inDictionaries:[Dictionary occupationArray]];
    if (index == NSNotFound) index = 0;
    [occupationPickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == countryPickerView.pickerView)
        return [Dictionary countryArray].count;
    else if (pickerView == identityTypePickerView.pickerView)
        return [Dictionary identityTypeArray].count;
//    else if (pickerView == personTypePickerView.pickerView)
//        return [Dictionary personTypeArray].count;
//    else if (pickerView == personAreaTypePickerView.pickerView)
//        return [Dictionary personAreaTypeArray].count;
//    else if (pickerView == genderPickerView.pickerView)
//        return [Dictionary genderArray].count;
    else
        return [Dictionary occupationArray].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == countryPickerView.pickerView)
        return ((Dictionary *)[Dictionary countryArray][row]).text;
    else if (pickerView == identityTypePickerView.pickerView)
        return ((Dictionary *)[Dictionary identityTypeArray][row]).text;
//    else if (pickerView == personTypePickerView.pickerView)
//        return ((Dictionary *)[Dictionary personTypeArray][row]).text;
//    else if (pickerView == personAreaTypePickerView.pickerView)
//        return ((Dictionary *)[Dictionary personAreaTypeArray][row]).text;
//    else if (pickerView == genderPickerView.pickerView)
//        return ((Dictionary *)[Dictionary genderArray][row]).text;
    else
        return ((Dictionary *)[Dictionary occupationArray][row]).text;
}

- (void)didClickedDoneButton:(PickerWidget *)pickerWidget {
    
    NSInteger row = [pickerWidget.pickerView selectedRowInComponent:0];
    
    if (pickerWidget == countryPickerView)
        [BookInfo defaultBookInfo].country = ((Dictionary *)[Dictionary countryArray][row]).value;
    else if (pickerWidget == identityTypePickerView)
        [BookInfo defaultBookInfo].identityType = ((Dictionary *)[Dictionary identityTypeArray][row]).value;
//    else if (pickerWidget == personTypePickerView)
//        [BookInfo defaultBookInfo].personType = ((Dictionary *)[Dictionary personTypeArray][row]).value;
//    else if (pickerWidget == personAreaTypePickerView)
//        [BookInfo defaultBookInfo].personAreaType = ((Dictionary *)[Dictionary personAreaTypeArray][row]).value;
//    else if (pickerWidget == genderPickerView)
//        [BookInfo defaultBookInfo].gender = ((Dictionary *)[Dictionary genderArray][row]).value;
    else if (pickerWidget == occupationPickerView)
        [BookInfo defaultBookInfo].occupation = ((Dictionary *)[Dictionary occupationArray][row]).value;
    
    [self fillData];
}

- (void)didClickedDateDoneButton:(DatePickerWidget *)datePickerWidget {
    
    if (datePickerWidget == identityExpireDatePickerView)
        [BookInfo defaultBookInfo].identityExpireDate = datePickerWidget.datePickerView.date;
//    else if (datePickerWidget == birthdayPickerView)
//        [BookInfo defaultBookInfo].birthday = datePickerWidget.datePickerView.date;
    
    [self fillData];
}

@end
