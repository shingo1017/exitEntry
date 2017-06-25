//
//  UIViewController+Additions.h
//  copybook
//
//  Created by 尹楠 on 15/2/6.
//  Copyright (c) 2015年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

@property (nonatomic, readwrite) UIViewController *popupViewController;
@property (nonatomic, readwrite) BOOL useBlurForPopup;

- (void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissPopupViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)setUseBlurForPopup:(BOOL)useBlurForPopup;
- (BOOL)useBlurForPopup;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
