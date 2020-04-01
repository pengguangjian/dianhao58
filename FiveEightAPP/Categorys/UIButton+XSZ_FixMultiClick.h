//
//  UIButton+XSZ_FixMultiClick.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/9/29.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XSZ_FixMultiClick)
@property (nonatomic, assign) NSTimeInterval xsz_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval xsz_acceptEventTime;

@end
