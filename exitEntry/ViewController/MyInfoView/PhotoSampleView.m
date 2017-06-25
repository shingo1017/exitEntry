//
//  PhotoSampleView.m
//  exitEntry
//
//  Created by 尹楠 on 17/4/11.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "PhotoSampleView.h"

@interface PhotoSampleView ()

@end

@implementation PhotoSampleView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navigationBarWidget.title = text(@"标准照片示例");
    
    zoomScrollView.minimumZoomScale = 1.0;
    zoomScrollView.maximumZoomScale = 2.0;
    
    photoImageView.image = [UIImage imageNamed:self.photoName];
    zoomScrollView.contentSize = CGSizeMake(photoImageView.image.size.width, photoImageView.image.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return photoImageView;
}

@end
