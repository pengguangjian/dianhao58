//
//  AppDelegate+ThirdPartyRegister.m
//  TechnicianAPP
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "AppDelegate+ThirdPartyRegister.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "MTA.h"
#import "MTAConfig.h"

#import <Bugly/Bugly.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AudioToolbox/AudioToolbox.h>


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (ThirdPartyRegister)<JPUSHRegisterDelegate>
@end

@implementation AppDelegate (ThirdPartyRegister)

#pragma mark - 注册高德地图
- (void)registerAMap {
    //添加开启 HTTPS 功能
//    [[AMapServices sharedServices] setEnableHTTPS:YES];
//    //设置apiKey
//    [AMapServices sharedServices].apiKey = @"1a2d439e7b78699ec3b97c6db76e931b";
}

#pragma mark - 注册ShareSDK
- (void)registerShareSDK {
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
       //QQ
//       [platformsRegister setupQQWithAppId:@"100371282" appkey:@"aed9b0303e3ed1e27bae87c33761161d"];
//
//        //WX
//       //更新到4.3.3或者以上版本，微信初始化需要使用以下初始化
//        [platformsRegister setupWeChatWithAppId:@"wx617c77c82218ea2c" appSecret:@"c7253e5289986cf4c4c74d1ccc185fb1" universalLink:@"https://www.sandslee.com/"];
//        
//      //新浪
//       [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];

      //Facebook
       [platformsRegister setupFacebookWithAppkey:@"3152144611465581" appSecret:@"1aecfb81e74d9e182d43341d9cd5afd9" displayName:@"ALOVN"];
    
    }];
    
    
}

- (void)registerMTASDK {
    
    [[MTAConfig getInstance] setSmartReporting:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    
//    [[MTAConfig getInstance] setDebugEnable:YES];
    
    [[MTAConfig getInstance] setAutoTrackPage:NO];
    
    [MTA startWithAppkey:@"I17V7S8PEDZZ"];
}

- (void)registerBuglySDK {
    //初始化Bugly
    [Bugly startWithAppId:@"1c6eb3ab29"];
}

- (void)initJPush_APNs {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

- (void)initJPush:(NSDictionary *)launchOptions {
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。

    NSString *appKey = @"12536fc737695cba691caf99";
    NSString *channel = @"App Store";
    BOOL isProduction;

#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif

    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];//advertisingId
}


- (void)registerDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    BOOL isOpenPush = [[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenPush"];
    
    if ([User sharedUser].user_id && [User sharedUser].user_id.length>0 && isOpenPush) {
        
        [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",[[Util getUDID] stringByReplacingOccurrencesOfString:@"-" withString:@""],[User sharedUser].user_id] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"");
        } seq:0];
    }
    
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        //显示Bagde
        UITabBarController *tabBarCtrl = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        UINavigationController *navi = [tabBarCtrl.viewControllers objectAtIndex:2];
//        OrderVC *orderVC = [navi.viewControllers firstObject];
//        orderVC.badgeView.hidden = NO;
        
        [self playNewMessageSound];
        [self playVibration];
    }
    completionHandler(UNNotificationPresentationOptionBadge); //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        //显示Bagde
        UITabBarController *tabBarCtrl = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        UINavigationController *navi = [tabBarCtrl.viewControllers objectAtIndex:2];
//        OrderVC *orderVC = [navi.viewControllers firstObject];
//        orderVC.badgeView.hidden = NO;
        
        [self playNewMessageSound];
        [self playVibration];
    }
    completionHandler(UNNotificationPresentationOptionBadge);  // 系统要求执行这个方法
}


- (SystemSoundID)playNewMessageSound
{
    // Path for the audio file
    //    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"];
    //    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"in.caf" withExtension:nil];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(soundID,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          nil, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(soundID);
    
    return soundID;
}

- (void)playVibration
{
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          nil, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

///**
// *  播放完成回调函数
// *
// *  @param soundID    系统声音ID
// *  @param clientData 回调时传递的数据
// */
//void soundCompleteCallback(SystemSoundID soundID, void *clientData) {
//    NSLog(@"播放完成...");
//}

@end
