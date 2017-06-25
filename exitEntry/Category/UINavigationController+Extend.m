//
//  UINavigationController+Extend.m
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "UINavigationController+Extend.h"

@implementation UINavigationController(Extend)

- (void)pushAnimationDidStop {
}

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition {
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return poppedController;
}

@end
