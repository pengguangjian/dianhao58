//
//  HomeDetailContentModel.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/28.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeDetailContentModel.h"

@implementation HomeDetailContentModel
+(HomeDetailContentModel *)dicToModelValue:(NSDictionary *)dic
{
    HomeDetailContentModel *model = [HomeDetailContentModel new];
    model.did = [NSString nullToString:[dic objectForKey:@"id"]];
    model.content = [NSString nullToString:[dic objectForKey:@"content"]];
    model.user_id = [NSString nullToString:[dic objectForKey:@"user_id"]];
    model.create_date = [NSString nullToString:[dic objectForKey:@"create_date"]];
    NSDictionary *dicuserinfo = [dic objectForKey:@"userinfo"];
    model.userinfoid = [NSString nullToString:[dicuserinfo objectForKey:@"id"]];
    model.userinfonickname = [NSString nullToString:[dicuserinfo objectForKey:@"nickname"]];
    model.userinfoavatar = [NSString nullToString:[dicuserinfo objectForKey:@"avatar"]];
    
    @try {
        NSDictionary *dictouser = [dic objectForKey:@"touser"];
        model.touserid = [NSString nullToString:[dictouser objectForKey:@"id"]];
        model.tousernickname = [NSString nullToString:[dictouser objectForKey:@"nickname"]];
        model.touseravatar = [NSString nullToString:[dictouser objectForKey:@"avatar"]];
        if(model.touserid.length>0)
        {
            model.ishuifu = YES;
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    
    return model;
    
    
}
@end
