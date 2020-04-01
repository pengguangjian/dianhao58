//
//  FETabBar.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FETabBarCenterButtonPosition){
    FETabBarCenterButtonPositionCenter, // 居中
    FETabBarCenterButtonPositionBulge // 凸出一半
};

@interface FETabBar : UITabBar
/**
 中间按钮
 */
@property (nonatomic, strong) UIButton *centerBtn;

/**
 中间按钮图片
 */
@property (nonatomic, strong) UIImage *centerImage;
/**
 中间按钮选中图片
 */
@property (nonatomic, strong) UIImage *centerSelectedImage;

/**
 中间按钮偏移量,两种可选，也可以使用centerOffsetY 自定义
 */
@property (nonatomic, assign) FETabBarCenterButtonPosition position;

/**
 中间按钮偏移量，默认是居中
 */
@property (nonatomic, assign) CGFloat centerOffsetY;

/**
 中间按钮的宽和高，默认使用图片宽高
 */
@property (nonatomic, assign) CGFloat centerWidth, centerHeight;

@end
