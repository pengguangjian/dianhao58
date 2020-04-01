//
//  ThirePlatformLogin.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/1.
//  Copyright © 2016年 xida. All rights reserved.
//


#import "ThirdPlatformLogin.h"

@implementation ThirdPlatformLogin

+ (instancetype)sharedThirdPlatformLogin {
    static dispatch_once_t onceToken;
    static ThirdPlatformLogin *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ThirdPlatformLogin alloc] init];
    });
    return instance;
}

//登录微信
- (void)loginWechat {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeFacebook
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               
               if (state == SSDKResponseStateSuccess) {
                   
                   if (self.thirdPlatformLoginHandler) {
                       self.thirdPlatformLoginHandler(user);
                   }
                   
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       [SVProgressHUD showWithStatus:@"正在登录..."];
//                   });
                   
               } else {
                   NSLog(@"%@",error);
                   
               }
               
           }];

}

//登录QQ
- (void)loginQQ {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               
               if (state == SSDKResponseStateSuccess) {
                   
                   if (self.thirdPlatformLoginHandler) {
                       self.thirdPlatformLoginHandler(user);
                   }
                   
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       
//                       [SVProgressHUD showWithStatus:@"正在登录..."];
//                   });
                   
               } else {
                   NSLog(@"%@",error);
                   
               }
               
           }];
    
}

//登录微博
- (void)loginSina {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               
               if (state == SSDKResponseStateSuccess) {
                   
                   if (self.thirdPlatformLoginHandler) {
                       self.thirdPlatformLoginHandler(user);
                   }
                   
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       [SVProgressHUD showWithStatus:@"正在登录..."];
//                   });
                   
               } else {
                   NSLog(@"%@",error);
                   
                   
               }
               
           }];
    
}






@end
