//
//  AppDelegate+ThirdPartyRegister.h
//  TechnicianAPP
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ThirdPartyRegister)
- (void)registerAMap;
- (void)registerShareSDK;
- (void)registerMTASDK;
- (void)registerBuglySDK;

- (void)initJPush_APNs;
- (void)initJPush:(NSDictionary *)launchOptions;
- (void)registerDeviceToken:(NSData *)deviceToken;
- (void)handleRemoteNotification:(NSDictionary *)userInfo;
@end
