//
//  VisaInfoView.m
//  copybook
//
//  Created by 尹楠 on 15/11/25.
//  Copyright © 2015年 尹楠. All rights reserved.
//

#import "VisaInfoView.h"
#import "TextInfoTableCell.h"
#import "TextEditTableCell.h"
#import "ImageInfoTableCell.h"
#import "BookAPI.h"
#import "BookInfo.h"
#import "StayInfoView.h"
#import "UIImage+Additions.h"
#import "PhotoSampleView.h"

@interface VisaInfoView () {

    UIImage *_image;
    NSInteger _selectedIndex;
}

@end

@implementation VisaInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BACKGROUND_COLOR;
    navigationBarWidget.title = text(@"入境及签证（注）信息");
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"下一张表")];
    
    visaTypePickerView.pickerView.dataSource = self;
    visaTypePickerView.pickerView.delegate = self;
    stayReasonPickerView.pickerView.dataSource = self;
    stayReasonPickerView.pickerView.delegate = self;
//    entryPortPickerView.pickerView.dataSource = self;
//    entryPortPickerView.pickerView.delegate = self;

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
            [BookInfo defaultBookInfo].enterPhotoUrl = [NSURL URLWithString:result[@"url"]];
        else
            [BookInfo defaultBookInfo].visaPhotoUrl = [NSURL URLWithString:result[@"url"]];
        [[BookInfo defaultBookInfo] save];
        
        [self->infoTableView reloadData];
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
    
    NSString *errorMessage = [[BookInfo defaultBookInfo] visaInfoVerification];
    if (errorMessage.length > 0)
        [MBProgressHUD showError:errorMessage];
    else {
        
        StayInfoView *stayInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"StayInfoView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:stayInfoView animated:YES];
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

    if ([[BookInfo defaultBookInfo] isGAT])
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([[BookInfo defaultBookInfo] isGAT]) {
        
        return 1;
    }
    else {
        
        if (section == 0)
            return 2;
        else
            return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![[BookInfo defaultBookInfo] isGAT] && indexPath.section == 0)
        return 90;
    else
        return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *textInfoTableCellId = @"TextInfoTableCell";
    NSString *imageInfoTableCellId = @"ImageInfoTableCell";

    if ([[BookInfo defaultBookInfo] isGAT]) {
        
//        if (indexPath.row == 0) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"入境日期");
//            if ([BookInfo defaultBookInfo].enterDate)
//                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].enterDate stringValue];
//            else
//                textInfoTableCell.valueLabel.text = text(@"入境日期占位符");
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].enterDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        else if (indexPath.row == 1) {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"入境口岸");
//            if ([BookInfo defaultBookInfo].entryPort.length > 0)
//                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].entryPort inDictionaries:[Dictionary entryPortArray]];
//            else
//                textInfoTableCell.valueLabel.text = text(@"入境口岸占位符");
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].entryPort.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
//        if (indexPath.row == 0) {
        
            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
            textInfoTableCell.captionLabel.text = text(@"停留事由");
            if ([BookInfo defaultBookInfo].stayReason.length > 0)
                textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].stayReason inDictionaries:[Dictionary stayReasonArray]];
            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].stayReason.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
            return textInfoTableCell;
//        }
//        else {
//            
//            TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//            textInfoTableCell.captionLabel.text = text(@"停留有效期");
//            if ([BookInfo defaultBookInfo].stayExpireDate)
//                textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].stayExpireDate stringValue];
//            else
//                textInfoTableCell.valueLabel.text = text(@"停留有效期占位符");
//            textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].stayExpireDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
//            return textInfoTableCell;
//        }
    }
    else {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                ImageInfoTableCell *imageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:imageInfoTableCellId forIndexPath:indexPath];
                imageInfoTableCell.captionLabel.text = text(@"入境页照片");
                [imageInfoTableCell.valueImageView sd_setImageWithURL:[BookInfo defaultBookInfo].enterPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
                imageInfoTableCell.imageSize = CGSizeMake(40, 60);
                return imageInfoTableCell;
            }
            else {
                
                ImageInfoTableCell *imageInfoTableCell = [tableView dequeueReusableCellWithIdentifier:imageInfoTableCellId forIndexPath:indexPath];
                imageInfoTableCell.captionLabel.text = text(@"签证页照片");
                [imageInfoTableCell.valueImageView sd_setImageWithURL:[BookInfo defaultBookInfo].visaPhotoUrl placeholderImage:[UIImage imageNamed:@"默认照片"]];
                imageInfoTableCell.imageSize = CGSizeMake(40, 60);
                return imageInfoTableCell;
            }
        }
        else {
            
            if (indexPath.row == 0) {
                
                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
                textInfoTableCell.captionLabel.text = text(@"签证（注）种类");
                if ([BookInfo defaultBookInfo].visaType.length > 0)
                    textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].visaType inDictionaries:[Dictionary visaTypeArray]];
                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].visaType.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
                return textInfoTableCell;
            }
            else if (indexPath.row == 1) {
                
                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
                textInfoTableCell.captionLabel.text = text(@"签证（注）有效期");
                if ([BookInfo defaultBookInfo].visaExpireDate)
                    textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].visaExpireDate stringValue];
                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].visaExpireDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
                return textInfoTableCell;
            }
//            else if (indexPath.row == 2) {
//                
//                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//                textInfoTableCell.captionLabel.text = text(@"入境日期");
//                if ([BookInfo defaultBookInfo].enterDate)
//                    textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].enterDate stringValue];
//                else
//                    textInfoTableCell.valueLabel.text = text(@"入境日期占位符");
//                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].enterDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
//                return textInfoTableCell;
//            }
//            else if (indexPath.row == 3) {
//                
//                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//                textInfoTableCell.captionLabel.text = text(@"入境口岸");
//                if ([BookInfo defaultBookInfo].entryPort.length > 0)
//                    textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].entryPort inDictionaries:[Dictionary entryPortArray]];
//                else
//                    textInfoTableCell.valueLabel.text = text(@"入境口岸占位符");
//                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].entryPort.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
//                return textInfoTableCell;
//            }
            else {
                
                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
                textInfoTableCell.captionLabel.text = text(@"停留事由");
                if ([BookInfo defaultBookInfo].stayReason.length > 0)
                    textInfoTableCell.valueLabel.text = [Dictionary textForValue:[BookInfo defaultBookInfo].stayReason inDictionaries:[Dictionary stayReasonArray]];
                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].stayReason.length > 0 ? TITLE_COLOR : PLACEHOLDER_COLOR;
                return textInfoTableCell;
            }
//            else {
//                
//                TextInfoTableCell *textInfoTableCell = [tableView dequeueReusableCellWithIdentifier:textInfoTableCellId forIndexPath:indexPath];
//                textInfoTableCell.captionLabel.text = text(@"停留有效期");
//                if ([BookInfo defaultBookInfo].stayExpireDate)
//                    textInfoTableCell.valueLabel.text = [[BookInfo defaultBookInfo].stayExpireDate stringValue];
//                else
//                    textInfoTableCell.valueLabel.text = text(@"停留有效期占位符");
//                textInfoTableCell.valueLabel.textColor = [BookInfo defaultBookInfo].stayExpireDate ? TITLE_COLOR : PLACEHOLDER_COLOR;
//                return textInfoTableCell;
//            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([[BookInfo defaultBookInfo] isGAT]) {
        
//        if (indexPath.row == 0)
//            [self showEnterDatePickerView];
//        else if (indexPath.row == 1)
//            [self showEntryPortPickerView];
        if (indexPath.row == 0)
            [self showStayReasonPickerView];
//        else if (indexPath.row == 1)
//            [self showStayExpireDatePickerView];
    }
    else {
        
        if (indexPath.section == 0) {
            
            _selectedIndex = indexPath.row;
            [self showPhotoPickerView];
        }
        else {
            
            if (indexPath.row == 0)
                [self showVisaTypePickerView];
            else if (indexPath.row == 1)
                [self showVisaExpireDatePickerView];
//            else if (indexPath.row == 2)
//                [self showEnterDatePickerView];
//            else if (indexPath.row == 3)
//                [self showEntryPortPickerView];
            else if (indexPath.row == 2)
                [self showStayReasonPickerView];
//            else if (indexPath.row == 3)
//                [self showStayExpireDatePickerView];
        }
    }
}

#pragma mark Select Row Methods

- (void)showPhotoPickerView {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text(@"请选择...") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:text(@"标准照片示例") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        
        PhotoSampleView *photoSampleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSampleView"];
        photoSampleView.photoName = _selectedIndex == 0 ? @"入境章页示例照片" : @"签证页示例照片";
        [MAIN_NAVIGATIONCONTROLLER pushViewController:photoSampleView animated:YES];
    }]];
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
    
    [visaTypePickerView hide];
    [visaExpireDatePickerView hide];
//    [enterDatePickerView hide];
//    [entryPortPickerView hide];
    [stayReasonPickerView hide];
//    [stayExpireDatePickerView hide];
}

- (void)showVisaTypePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [visaTypePickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].visaType inDictionaries:[Dictionary visaTypeArray]];
    if (index == NSNotFound) index = 0;
    [visaTypePickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)showVisaExpireDatePickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [visaExpireDatePickerView show];
    if ([BookInfo defaultBookInfo].visaExpireDate)
        [visaExpireDatePickerView.datePickerView setDate:[BookInfo defaultBookInfo].visaExpireDate animated:NO];
    else
        [visaExpireDatePickerView.datePickerView setDate:[NSDate date] animated:NO];
}

//- (void)showEnterDatePickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [enterDatePickerView show];
//    if ([BookInfo defaultBookInfo].enterDate)
//        [enterDatePickerView.datePickerView setDate:[BookInfo defaultBookInfo].enterDate animated:NO];
//    else
//        [enterDatePickerView.datePickerView setDate:[NSDate date] animated:NO];
//}
//
//- (void)showEntryPortPickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [entryPortPickerView show];
//    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].entryPort inDictionaries:[Dictionary entryPortArray]];
//    if (index == NSNotFound) index = 0;
//    [entryPortPickerView.pickerView selectRow:index inComponent:0 animated:NO];
//}

- (void)showStayReasonPickerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
    
    [self hideAllPickerView];
    [stayReasonPickerView show];
    NSInteger index = [Dictionary indexForValue:[BookInfo defaultBookInfo].stayReason inDictionaries:[Dictionary stayReasonArray]];
    if (index == NSNotFound) index = 0;
    [stayReasonPickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

//- (void)showStayExpireDatePickerView {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_SHOULD_DISMISS_KEYBOARD_NOTIFICATION object:nil];
//    
//    [self hideAllPickerView];
//    [stayExpireDatePickerView show];
//    if ([BookInfo defaultBookInfo].stayExpireDate)
//        [stayExpireDatePickerView.datePickerView setDate:[BookInfo defaultBookInfo].stayExpireDate animated:NO];
//    else
//        [stayExpireDatePickerView.datePickerView setDate:[NSDate date] animated:NO];
//}

#pragma mark UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == visaTypePickerView.pickerView)
        return [Dictionary visaTypeArray].count;
//    else if (pickerView == entryPortPickerView.pickerView)
//        return [Dictionary entryPortArray].count;
    else
        return [Dictionary stayReasonArray].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == visaTypePickerView.pickerView)
        return ((Dictionary *)[Dictionary visaTypeArray][row]).text;
//    else if (pickerView == entryPortPickerView.pickerView)
//        return ((Dictionary *)[Dictionary entryPortArray][row]).text;
    else
        return ((Dictionary *)[Dictionary stayReasonArray][row]).text;
}

- (void)didClickedDoneButton:(PickerWidget *)pickerWidget {
    
    NSInteger row = [pickerWidget.pickerView selectedRowInComponent:0];
    
    if (pickerWidget == visaTypePickerView)
        [BookInfo defaultBookInfo].visaType = ((Dictionary *)[Dictionary visaTypeArray][row]).value;
//    else if (pickerWidget == entryPortPickerView)
//        [BookInfo defaultBookInfo].entryPort = ((Dictionary *)[Dictionary entryPortArray][row]).value;
    else if (pickerWidget == stayReasonPickerView)
        [BookInfo defaultBookInfo].stayReason = ((Dictionary *)[Dictionary stayReasonArray][row]).value;
    
    [self fillData];
}

- (void)didClickedDateDoneButton:(DatePickerWidget *)datePickerWidget {
    
    if (datePickerWidget == visaExpireDatePickerView) {
        
        [BookInfo defaultBookInfo].visaExpireDate = datePickerWidget.datePickerView.date;
    }
//    else if (datePickerWidget == enterDatePickerView) {
//        
//        [BookInfo defaultBookInfo].enterDate = datePickerWidget.datePickerView.date;
//    }
//    else if (datePickerWidget == stayExpireDatePickerView) {
//        
//        [BookInfo defaultBookInfo].stayExpireDate = datePickerWidget.datePickerView.date;
//    }
    
    [self fillData];
}

@end
