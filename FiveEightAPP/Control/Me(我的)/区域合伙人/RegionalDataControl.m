//
//  RegionalDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/30.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "RegionalDataControl.h"
#import "GMDCircleLoader.h"

@implementation RegionalDataControl
///合伙人申请
-(void)regionalData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.areaPartner/apply" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
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
