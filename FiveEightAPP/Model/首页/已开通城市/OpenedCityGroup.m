//
//  OpenedCityGroup.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/26.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "OpenedCityGroup.h"
#import "OpenedCity.h"
#import "PinYin4Objc.h"

@implementation OpenedCityGroup

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    NSMutableArray *tempArray = [NSMutableArray array];
    OpenedCityGroup *group = [[OpenedCityGroup alloc] init];
    for (OpenedCity *oc in dataArray)
    {
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:oc.title];
        if ([header isEqualToString:title])
        {
            [tempArray addObject:oc];
        }
    }
    group.groupTitle = title;
    group.cityArr = tempArray;
    return group;
}

@end
