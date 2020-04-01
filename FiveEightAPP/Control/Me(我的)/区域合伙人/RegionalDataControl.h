//
//  RegionalDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/30.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface RegionalDataControl : NSObject

///合伙人申请
-(void)regionalData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
