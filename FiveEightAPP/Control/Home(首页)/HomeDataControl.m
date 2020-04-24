//
//  HomeDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeDataControl.h"
#import "GMDCircleLoader.h"
@implementation HomeDataControl

///获取首页栏目数据
-(void)homeLanMuData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:@"" animated:YES];
    }
    
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.channel/lists" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrLanMu = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

-(void)homeNewMessageData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.city/newest" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrNewMessage =  [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

-(void)homeLunBoImageData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.page/home" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrLunBoImage =  [[dicAll objectForKey:@"data"] objectForKey:@"banner"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

-(void)hotLanMuData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.hot/hotlist" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrhotLanMu =  [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

///用户信息
-(void)userInfoData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/index" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_userinfoData =  [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

@end
