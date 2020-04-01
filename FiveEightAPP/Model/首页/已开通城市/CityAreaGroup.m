//
//  CityAreaGroup.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "CityAreaGroup.h"
#import "CityArea.h"
#import "PinYin4Objc.h"

@implementation CityAreaGroup

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    NSMutableArray *tempArray = [NSMutableArray array];
    CityAreaGroup *group = [[CityAreaGroup alloc] init];
    for (CityArea *ca in dataArray)
    {
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:ca.name];
        if ([header isEqualToString:title])
        {
            [tempArray addObject:ca];
        }
    }
    group.groupTitle = title;
    group.cityAreaArr = tempArray;
    return group;
}

@end
