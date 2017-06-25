//
//  UINavigationController+Extend.h
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(Extend)

- (void)pushViewController: (UIViewController*)controller animatedWithTransition: (UIViewAnimationTransition)transition;
- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;
- (void)pushAnimationDidStop;

@end
