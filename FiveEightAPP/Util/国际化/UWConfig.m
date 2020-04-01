//
//  UWConfig.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/25.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "UWConfig.h"

static NSString *const UWUserLanguageKey = @"UWUserLanguageKey";
#define STANDARD_USER_DEFAULT  [NSUserDefaults standardUserDefaults]

@implementation UWConfig

+ (void)setUserLanguage:(NSString *)userLanguage
{
    //跟随手机系统
    if (!userLanguage.length) {
        [self resetSystemLanguage];
        return;
    }
    //用户自定义
    [STANDARD_USER_DEFAULT setValue:userLanguage forKey:UWUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

+ (NSString *)userLanguage
{
    return [STANDARD_USER_DEFAULT valueForKey:UWUserLanguageKey];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage
{
    [STANDARD_USER_DEFAULT removeObjectForKey:UWUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:nil forKey:@"AppLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

@end
