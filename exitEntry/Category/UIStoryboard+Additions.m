//
//  UIStoryboard+Additions.m
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "UIStoryboard+Additions.h"

@implementation UIStoryboard(Additions)

+ (id)viewControllerWithName:(NSString *)name {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:name];
}

@end
