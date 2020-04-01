//
//  YDScrollView.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/22.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "YDScrollView.h"

@implementation YDScrollView

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    // 获取一个UITouch
    UITouch *touch = [touches anyObject];
    // 获取当前的位置
    CGPoint current = [touch locationInView:self];
    CGFloat x = [UIScreen mainScreen].bounds.size.width;
    
//    NSLog(@"current.x:%f, x:%f",current.x, x);
    
    if (current.x >= x + 10) {
        //在地图上
        //        NSLog(@"在地图上, 不滚动, view class is %@", view.class);
        return YES;
    } else {
        return [super touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    //    NSLog(@"cancle class is %@", view.class);
    if ([view isKindOfClass:NSClassFromString(@"TapDetectingView")]) {
        return NO;
    } else {
        return [super touchesShouldCancelInContentView:view];
    }
}

@end
