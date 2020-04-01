//
//  HomeLanMuModel.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeLanMuModel.h"

@implementation HomeLanMuModel

+(HomeLanMuModel *)dicToModelValue:(NSDictionary *)dic
{
    HomeLanMuModel *model = [HomeLanMuModel new];
    model.did = [NSString nullToString:[dic objectForKey:@"id"]];
    model.flag = [NSString nullToString:[dic objectForKey:@"flag"]];
    model.name = [NSString nullToString:[dic objectForKey:@"name"]];
    model.diyname = [NSString nullToString:[dic objectForKey:@"diyname"]];
    model.image = [NSString nullToString:[dic objectForKey:@"image"]];
    model.parent_id = [NSString nullToString:[dic objectForKey:@"parent_id"]];
    model.type = [NSString nullToString:[dic objectForKey:@"type"]];
    model.keywords = [NSString nullToString:[dic objectForKey:@"keywords"]];
    model.desc = [NSString nullToString:[dic objectForKey:@"description"]];
    model.channeltpl = [NSString nullToString:[dic objectForKey:@"channeltpl"]];
    model.listtpl = [NSString nullToString:[dic objectForKey:@"listtpl"]];
    model.showtpl = [NSString nullToString:[dic objectForKey:@"showtpl"]];
    
    if([[dic objectForKey:@"son"] isKindOfClass:[NSArray class]])
    {
        NSArray *son = [dic objectForKey:@"son"];
        NSMutableArray *arrtemp = [NSMutableArray new];
        for(NSDictionary *dictemp in son)
        {
            HomeLanMuModel *models = [HomeLanMuModel new];
            models.did = [NSString nullToString:[dictemp objectForKey:@"id"]];
            models.flag = [NSString nullToString:[dictemp objectForKey:@"flag"]];
            models.name = [NSString nullToString:[dictemp objectForKey:@"name"]];
            models.diyname = [NSString nullToString:[dictemp objectForKey:@"diyname"]];
            models.image = [NSString nullToString:[dictemp objectForKey:@"image"]];
            models.parent_id = [NSString nullToString:[dictemp objectForKey:@"parent_id"]];
            models.type = [NSString nullToString:[dictemp objectForKey:@"type"]];
            models.keywords = [NSString nullToString:[dictemp objectForKey:@"keywords"]];
            models.desc = [NSString nullToString:[dictemp objectForKey:@"description"]];
            models.channeltpl = [NSString nullToString:[dictemp objectForKey:@"channeltpl"]];
            models.listtpl = [NSString nullToString:[dictemp objectForKey:@"listtpl"]];
            models.showtpl = [NSString nullToString:[dictemp objectForKey:@"showtpl"]];
            [arrtemp addObject:models];
        }
        model.arrson = arrtemp;
        
    }
    
    
    return model;
}

@end
