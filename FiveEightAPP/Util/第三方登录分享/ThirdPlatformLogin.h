//
//  ThirdPlatformLogin.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/1.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef void (^ThirdPlatformLoginHandler)(SSDKUser *user);

@interface ThirdPlatformLogin : NSObject

@property (nonatomic, copy) ThirdPlatformLoginHandler thirdPlatformLoginHandler;

+ (instancetype)sharedThirdPlatformLogin;

/**
 *  登录微信
 */
- (void)loginWechat;

/**
 *  登录QQ
 */
- (void)loginQQ;

/**
 *  登录微博
 */
- (void)loginSina;

@end
