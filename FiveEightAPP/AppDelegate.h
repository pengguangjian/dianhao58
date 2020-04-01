//
//  AppDelegate.h
//  FiveEight
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FETabBarController *tabBarCtrl;

@property (assign, nonatomic) NSUInteger lastTabbarIndex;

- (void)createRootVC;

@end

