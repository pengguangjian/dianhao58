//
//  FindModel.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel
+(FindModel *)dicModelValue:(NSDictionary *)dic
{
    FindModel *model = [FindModel new];
    model.thumb = [NSString nullToString:[dic objectForKey:@"thumb"]];
    model.title = [NSString nullToString:[dic objectForKey:@"title"]];
    model.updatetime = [NSString nullToString:[dic objectForKey:@"updatetime"]];
    model.url = [NSString nullToString:[dic objectForKey:@"url"]];
    
    return model;
}

@end
