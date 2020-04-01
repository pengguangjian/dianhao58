//
//  SmsProtoctFunction.h
//  FiveEightAPP
//
//  Created by Mac on 2020/4/1.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmsProtoctFunction : NSObject
///获取短信验证码
+(void)smsRegionalData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
