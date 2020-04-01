//
//  HomeBanKuaiDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeBanKuaiDataControl.h"
#import "GMDCircleLoader.h"
@implementation HomeBanKuaiDataControl
///获取栏目列表数据
-(void)homeLanMuItemListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.channel/posts" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = @"网络错误";
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrLanMuItemList = [[dicAll objectForKey:@"data"] objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

///搜索列表数据
-(void)homesearchListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.common/search" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = @"网络错误";
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrhomesearchLis = [[dicAll objectForKey:@"data"] objectForKey:@"list"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

@end
