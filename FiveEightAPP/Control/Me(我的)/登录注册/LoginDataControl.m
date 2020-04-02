//
//  LoginDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "LoginDataControl.h"
#import "GMDCircleLoader.h"

@implementation LoginDataControl
///登录
-(void)loginPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/login" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicLogin = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

///第三方登录
-(void)otherLoginPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/third" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicOtherLogin = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

///第三方绑定
-(void)otherLoginBangDingPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm postRequetInterfaceNoLangData:dicpush withInterfaceName:@"frontend.user/binding" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
                self->_dicOtherLoginBD = [dicAll objectForKey:@"data"];
                state = YES;
            }
        }
        back(error,state,describle);
    }];
    /*
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/binding" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicOtherLoginBD = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    */
}

///手机号登录
-(void)loginPhonePushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    
    
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/codeLogin" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicLoginPhone = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

//判断账号是否存在
-(void)phoneIsAccountPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/isNewUser" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicPhoneIs = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

///注册
-(void)resignPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/register" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               self->_dicResign = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

///重置密码
-(void)resetpwdData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
       {
           [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
       }
       HttpManager *httpm = [HttpManager createHttpManager];
       [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.user/resetpwd" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
                  state = YES;
              }
          }
          back(error,state,describle);
       }];
    
}

@end
