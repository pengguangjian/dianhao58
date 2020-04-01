//
//  NSString+TimeStamp.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//


// 时间戳工具
#import <Foundation/Foundation.h>

@interface NSString (TimeStamp)

// 获取当前时间戳
+ (NSInteger)getCurrentTimeStamp;


// 系统带的算法 根据UUID生成的 每次返回的string不一样
+ (NSString *)getUniqueStrByUUID;


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
