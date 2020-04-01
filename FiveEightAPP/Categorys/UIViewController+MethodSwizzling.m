//
//  UIViewController+MethodSwizzling.m
//  MeiShi
//
// Created by caochun on 16/3/23.
//
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (MethodSwizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            Method originMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzling_viewDidAppear:));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)swizzling_viewDidAppear:(BOOL)animated
{
    [self swizzling_viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

@end
