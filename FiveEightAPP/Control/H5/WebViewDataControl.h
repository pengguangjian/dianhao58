//
//  WebViewDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/4/3.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface WebViewDataControl : NSObject
@property (nonatomic,retain) NSDictionary *dicdata;

-(void)loadUrlData:(NSDictionary *)dicpush andurl:(NSString *)strurl andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
