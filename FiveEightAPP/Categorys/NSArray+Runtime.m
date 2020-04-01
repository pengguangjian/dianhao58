//
//  NSArray+Runtime.m
//  MeiShi
//
//  Created by caochun on 16/3/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "NSArray+Runtime.h"

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation NSArray (Runtime)

+ (void)load{
    
    //objectAtIndex
    Method orginalObjectAtIndexMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
    Method newObjectAtIndexMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(ms_objectAtIndex:));
    method_exchangeImplementations(orginalObjectAtIndexMethod, newObjectAtIndexMethod);
    
    Method originalMethod = class_getClassMethod(NSClassFromString(@"__NSArrayI"), @selector(arrayWithObjects:count:));
    Method newMethod = class_getClassMethod(NSClassFromString(@"__NSArrayI"), @selector(ms_arrayWithObjects:count:));
    method_exchangeImplementations(originalMethod, newMethod);
    
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


/**
 *  初始化时空对象报错的处理
 *
 *  @param objects 对象数组
 *  @param cnt     长度
 *
 *  @return instancetype
 */
+ (instancetype)ms_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    id nObjects[cnt];
    int i=0, j=0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i]) {
            nObjects[j] = objects[i];
            j++;
        }
    }
    
    return [self ms_arrayWithObjects:nObjects count:j];
}

@end
