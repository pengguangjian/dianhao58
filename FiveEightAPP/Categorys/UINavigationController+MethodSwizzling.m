//
//  UINavigationController+MethodSwizzling.m
//  MeiShi
//
//  Created by caochun on 16/3/23.
//
//

#import "UINavigationController+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation UINavigationController (MethodSwizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            Method originMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzling_pushViewController:animated:));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)swizzling_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    
    [self swizzling_pushViewController:viewController animated:animated];
}

@end
