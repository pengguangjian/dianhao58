//
//  BanKuaiModel.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "BanKuaiModel.h"

@implementation BanKuaiModel

+(BanKuaiModel *)dicToModelValue:(NSDictionary *)dic
{
    BanKuaiModel *model = [BanKuaiModel new];
    model.area_name = [NSString nullToString:[dic objectForKey:@"area_name"]];
    model.channel_name = [NSString nullToString:[dic objectForKey:@"channel_name"]];
    model.city_name = [NSString nullToString:[dic objectForKey:@"city_name"]];
    model.cover = [NSString nullToString:[dic objectForKey:@"cover"]];
    model.did = [NSString nullToString:[dic objectForKey:@"id"]];
    model.parent_channel_name = [NSString nullToString:[dic objectForKey:@"parent_channel_name"]];
    model.publishtime_text = [NSString nullToString:[dic objectForKey:@"publishtime_text"]];
    model.title = [NSString nullToString:[dic objectForKey:@"title"]];
    model.views = [NSString nullToString:[dic objectForKey:@"comments"]];
    model.mobile = [NSString nullToString:[dic objectForKey:@"mobile"]];
    model.image = [dic objectForKey:@"image"];
    model.content = [NSString nullToString:[dic objectForKey:@"content"]];
    model.authentication_status = [NSString nullToString:[dic objectForKey:@"authentication_status"]];
    
    model.contact = [NSString nullToString:[dic objectForKey:@"contact"]];
    
    return model;
}

@end
