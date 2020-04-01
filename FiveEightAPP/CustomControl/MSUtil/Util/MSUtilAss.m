//
//  MSUtilAss.m
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSUtilAss.h"

@implementation MSUtilAss

+ (NSString *)jsonInfo:(id)info andDefaultStr:(NSString *)defaultStr {
    if (!info) {
        return defaultStr;
    }
    
    if ([info isKindOfClass:[NSNull class]]) {
        return defaultStr;
    }
    
    if ([info isKindOfClass:[NSString class]]) {
        if ([info isNotEmptyWithSpace]) {
            //for service
            if ([info isEqualToString:@"<null>"]) {
                return defaultStr;
            }
            return [NSString stringWithFormat:@"%@", info];
        } else {
            return defaultStr;
        }
    }
    
    return [NSString stringWithFormat:@"%@", info];
    
    return @"";
}



@end




@implementation MSUtilAss(dataForTest)

@end
