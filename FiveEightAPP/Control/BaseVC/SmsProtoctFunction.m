//
//  SmsProtoctFunction.m
//  FiveEightAPP
//
//  Created by Mac on 2020/4/1.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "SmsProtoctFunction.h"
#import "GMDCircleLoader.h"

@implementation SmsProtoctFunction

///获取短信验证码
+(void)smsRegionalData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm postRequetInterfaceNoLangData:dicpush withInterfaceName:@"frontend.Sms/index" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
               describle = [NSString nullToString:[dicAll objectForKey:@"msg"]];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
}

@end
