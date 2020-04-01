//
//  NSBundle+UWUtils.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/25.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (UWUtils)

+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
