//
//  MessageModel.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+(MessageModel *)dicModelValue:(NSDictionary *)dic
{
    MessageModel *model = [MessageModel new];
    
    model.time = [NSString nullToString:[dic objectForKey:@"time"]];
    model.content = [NSString nullToString:[dic objectForKey:@"content"]];
    model.article_id = [NSString nullToString:[dic objectForKey:@"article_id"]];
    model.msg_type = [NSString nullToString:[dic objectForKey:@"msg_type"]];
    model.url = [NSString nullToString:[dic objectForKey:@"url"]];
//    model.content = @"山东会计法卢萨卡打飞机按时来得快发上来的看法收到了反馈沙街道口附近暗示领导发";
    model.fcellheight = 75+[Util countTextSize:CGSizeMake(DEVICE_Width-90, 40) andtextfont:[UIFont systemFontOfSize:14] andtext:model.content].height;
    
    
    return model;
}
@end
