//
//  NSMutableArray+Extension.m
//  MeiShi
//
//  Created by caochun on 16/3/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "NSMutableArray+Runtime.h"

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation NSMutableArray (Runtime)

+ (void)load{
    
    //添加nil保存的处理
    Method orginalAddObjectMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newAddObjectMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(ms_addObject:));
    /** 交换方法实现 */
    method_exchangeImplementations(orginalAddObjectMethod, newAddObjectMethod);
    
    //objectAtIndex
    Method orginalObjectAtIndexMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
    Method newObjectAtIndexMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(ms_objectAtIndex:));
    /** 交换方法实现 */
    method_exchangeImplementations(orginalObjectAtIndexMethod, newObjectAtIndexMethod);
    
}

/**
 *  添加空对象报错的处理
 *
 *  @param object id
 */
- (void)ms_addObject:(id)object{
    
    if (object) {
        [self ms_addObject:object];
    }
    
}

/**
 *  访问数组越界的处理
 *
 *  @param index NSUInteger
 *
 *  @return id
 */
- (instancetype)ms_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self ms_objectAtIndex:index];
    }else{
        return nil;
    }
}

@end
