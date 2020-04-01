//
//  UIButton+ImageTitleSpacing.h
//  GuoHuiAPP
//
//  Created by caochun on 16/10/7.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GHButtonEdgeInsetsStyle) {
    GHButtonEdgeInsetsStyleTop, // image在上，label在下
    GHButtonEdgeInsetsStyleLeft, // image在左，label在右
    GHButtonEdgeInsetsStyleBottom, // image在下，label在上
    GHButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(GHButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
