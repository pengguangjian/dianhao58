//
//  UIControl+XY.m
//  MeiShi
//
//  Created by caochun on 16/3/23.
//  Copyright © 2016年 More. All rights reserved.
//

#import "UIControl+Runtime.h"

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation UIControl (Runtime)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIcontrol_ignoreEvent = "UIcontrol_ignoreEvent";

- (NSTimeInterval)ms_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
//关联属性（动态添加）
- (void)setMs_acceptEventInterval:(NSTimeInterval)ms_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(ms_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)ms_ignoreEvent {
    
    return [objc_getAssociatedObject(self, UIcontrol_ignoreEvent) boolValue];
    
}

- (void)setMs_ignoreEvent:(BOOL)ms_ignoreEvent {
    
    objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(ms_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method newMethod = class_getInstanceMethod(self, @selector(ms_sendAction:to:forEvent:));
    method_exchangeImplementations(originalMethod, newMethod);
}

/**
 *  解决UIButton重复点击的问题
 *
 *  @param action SEL
 *  @param target id
 *  @param event  UIEvent
 */
//- (void)ms_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//{
//    if (self.ms_ignoreEvent) return;
//    if (self.ms_acceptEventInterval > 0)
//    {
//        self.ms_ignoreEvent = YES;
//        [self performSelector:@selector(setMs_ignoreEvent:) withObject:@(NO) afterDelay:self.ms_acceptEventInterval];
//    }
//    [self ms_sendAction:action to:target forEvent:event];
//}



@end
