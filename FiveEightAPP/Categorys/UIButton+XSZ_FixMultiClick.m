//
//  UIButton+XSZ_FixMultiClick.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/9/29.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "UIButton+XSZ_FixMultiClick.h"
#import <objc/runtime.h>

@implementation UIButton (XSZ_FixMultiClick)

// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)xsz_acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setXsz_acceptEventInterval:(NSTimeInterval)xsz_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(xsz_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)xsz_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setXsz_acceptEventTime:(NSTimeInterval)xsz_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(xsz_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
+ (void)load {
//    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after    = class_getInstanceMethod(self, @selector(xsz_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
    
    //-[UITabBarButton xsz_acceptEventTime]: unrecognized selector sent to instance 0x7fc9d8f36c50
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //分别获取
        SEL beforeSelector = @selector(sendAction:to:forEvent:);
        SEL afterSelector = @selector(xsz_sendAction:to:forEvent:);
        
        Method beforeMethod = class_getInstanceMethod(class, beforeSelector);
        Method afterMethod = class_getInstanceMethod(class, afterSelector);
        //先尝试给原来的方法添加实现，如果原来的方法不存在就可以添加成功。返回为YES，否则
        //返回为NO。
        //UIButton 真的没有sendAction方法的实现，这是继承了UIControl的而已，UIControl才真正的实现了。
        BOOL didAddMethod =
        class_addMethod(class,
                        beforeSelector,
                        method_getImplementation(afterMethod),
                        method_getTypeEncoding(afterMethod));
        NSLog(@"%d",didAddMethod);
        if (didAddMethod) {
            // 如果之前不存在，但是添加成功了，此时添加成功的是cs_sendAction方法的实现
            // 这里只需要方法替换
            class_replaceMethod(class,
                                afterSelector,
                                method_getImplementation(beforeMethod),
                                method_getTypeEncoding(beforeMethod));
        } else {
            //本来如果存在就进行交换
            method_exchangeImplementations(afterMethod, beforeMethod);
        }
    });
    
}

- (void)xsz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.xsz_acceptEventTime < self.xsz_acceptEventInterval) {
        return;
    }
    
    if (self.xsz_acceptEventInterval > 0) {
        self.xsz_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self xsz_sendAction:action to:target forEvent:event];
}

@end
