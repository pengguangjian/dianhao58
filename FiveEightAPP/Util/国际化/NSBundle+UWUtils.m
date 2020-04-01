//
//  NSBundle+UWUtils.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/25.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "NSBundle+UWUtils.h"

#import "UWConfig.h"
#import <objc/runtime.h>

@interface UWBundle : NSBundle

@end

@implementation NSBundle (UWUtils)

+ (BOOL)isChineseLanguage
{
    NSString *currentLanguage = [self currentLanguage];
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)currentLanguage
{
    return [UWConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类DABundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [UWBundle class]);
    });
}

@end

@implementation UWBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([UWBundle uw_mainBundle]) {
        return [[UWBundle uw_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)uw_mainBundle
{
    if ([NSBundle currentLanguage].length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}


@end
