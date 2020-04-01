//
//  FETabBarController.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETabBar.h"

@protocol FETabBarControllerDelegate<UITabBarControllerDelegate>

// 重写了选中方法，主要处理中间item选中事件
- (void)feTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface FETabBarController : UITabBarController
@property (nonatomic, weak) id<FETabBarControllerDelegate> feDelegate;
@property (nonatomic, strong) FETabBar *feTabbar;
@end
