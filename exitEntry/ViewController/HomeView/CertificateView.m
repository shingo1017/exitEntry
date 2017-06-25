//
//  CertificateView.m
//  exitEntry
//
//  Created by 尹楠 on 17/4/11.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "CertificateView.h"
#import "BookInfo.h"

@interface CertificateView ()

@end

@implementation CertificateView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navigationBarWidget.title = text(@"预览电子证件");
    navigationBarWidget.delegate = self;
    [navigationBarWidget addRightBarButtonWithTitle:text(@"下载")];
    
    zoomScrollView.minimumZoomScale = 1.0;
    zoomScrollView.maximumZoomScale = 2.0;
    
    [flipButton setTitle:text(@"查看背面照片") forState:UIControlStateNormal];
    [flipButton setTitle:text(@"查看正面照片") forState:UIControlStateSelected];
    
    [self flipToFace:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)flipToFace:(BOOL)isFace {
    
    NSURL *url = isFace ? [BookInfo defaultBookInfo].certificatePhotoUrl : [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" , Server_URL, @"generate/notice.jpg"]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationTransition:isFace ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:certificateImageView cache:YES];
    [certificateImageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        zoomScrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
    }];
    [UIView commitAnimations];
}

- (IBAction)flipButtonClicked:(id)sender {
    
    flipButton.selected = !flipButton.selected;
    
    [self flipToFace:!flipButton.selected];
}

#pragma mark NavigationBarWidgetDelegate method

- (void)didClickedRightBarButton:(NavigationBarWidget *)navigationBarWidget {
    
    if (certificateImageView.image)
    UIImageWriteToSavedPhotosAlbum(certificateImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    else
        [MBProgressHUD showError:text(@"电子证书图片暂时不能下载")];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error)
        [MBProgressHUD showSuccess:text(@"电子证件保存成功")];
    else
        [MBProgressHUD showError:error.localizedDescription];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return certificateImageView;
}

@end
