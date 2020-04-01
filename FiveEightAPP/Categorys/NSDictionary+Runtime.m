//
//  NSDictionary+Runtime.m
//  MeiShi
//
//  Created by caochun on 16/3/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "NSDictionary+Runtime.h"

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation NSDictionary (Runtime)

+ (void)load {
    Method originalMethod = class_getClassMethod(self, @selector(dictionaryWithObjects:forKeys:count:));
    Method newMethod = class_getClassMethod(self, @selector(ms_dictionaryWithObjects:forKeys:count:));
    method_exchangeImplementations(originalMethod, newMethod);
}

/**
 *  添加空对象报错的处理
 *
 *  @param objects value数组
 *  @param keys    key数组
 *  @param cnt     NSUInteger
 *
 *  @return instancetype
 */
+ (instancetype)ms_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id nObjects[cnt];
    id nKeys[cnt];
    int i = 0, j = 0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i] && keys[i]) {
            nObjects[j] = objects[i];
            nKeys[j] = keys[i];
            j++;
        }
    }
    
    return [self ms_dictionaryWithObjects:nObjects forKeys:nKeys count:j];
}

@end
