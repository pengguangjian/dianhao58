//
//  NSString+QHNSStringCtg.h
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSHead.h"

@interface NSString (MSNSStringCtg)

///去除空格判断是否为空
- (BOOL)isNotEmptyCtg;
///不去除空格判断是否为空
- (BOOL)isNotEmptyWithSpace;

///符号成套删除 可用于去除带有xml标记 如<color>
- (NSString*)stringByDeleteSignForm:(NSString *)aLeftSign
                       andRightSign:(NSString *)aRightSign;


- (NSString*)stringByReplacingSignForm:(NSString *)aLeftSign
                          andRightSign:(NSString *)aRightSign
                       andReplacingStr:(NSString*)aReplacingStr;


- (NSString *)QHURLEncodedString;

- (NSURL *)qh_url;

@end
