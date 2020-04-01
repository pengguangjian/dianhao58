//
//  NSMutableDictionary+Runtime.m
//  MeiShi
//
//  Created by caochun on 16/3/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "NSMutableDictionary+Runtime.h"

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation NSMutableDictionary (Runtime)

+ (void)load {
    Class dictCls = NSClassFromString(@"__NSDictionaryM");
    Method originalMethod = class_getInstanceMethod(dictCls, @selector(setObject:forKey:));
    Method newMethod = class_getInstanceMethod(dictCls, @selector(ms_setObject:forKey:));
    method_exchangeImplementations(originalMethod, newMethod);
}

/**
 *  添加空对象报错的处理
 *
 *  @param anObject id
 *  @param aKey     id
 */
- (void)ms_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (!anObject){
         return;
    }
    
    [self ms_setObject:anObject forKey:aKey];
}

@end
