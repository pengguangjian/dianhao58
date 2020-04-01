//
//  UIControl+XY.h
//  MeiShi
//
//  Created by caochun on 16/3/23.
//  Copyright © 2016年 More. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Runtime)
@property (nonatomic, assign) NSTimeInterval ms_acceptEventInterval;   // 可以用这个给重复点击加间隔
@property (nonatomic, assign) BOOL ms_ignoreEvent;
@end
