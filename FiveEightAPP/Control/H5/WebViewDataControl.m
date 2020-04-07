//
//  WebViewDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/4/3.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "WebViewDataControl.h"
#import "GMDCircleLoader.h"

@implementation WebViewDataControl
-(void)loadUrlData:(NSDictionary *)dicpush andurl:(NSString *)strurl andshowView:(UIView *)view Callback:(completItemback)back
{
    
    HttpManager *httpm = [HttpManager createHttpManager];
    [httpm getRequetInterfaceData:dicpush withInterfaceName:strurl andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_dicdata =  [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}
@end
