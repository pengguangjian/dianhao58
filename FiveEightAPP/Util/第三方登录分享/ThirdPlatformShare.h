//
//  ThirdPlatformShare.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/2.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ThirdPlatformShare : NSObject

/**
 *  分享
 *
 *  @param platformType  分享平台
 *  @param urlStr  分享地址
 *  @param title   标题
 *  @param content 内容
 *  @param image   图片
 */
+ (void)shareToThirdPlatform:(SSDKPlatformType)platformType
                  withUrlStr:(NSString*)urlStr
                   withTitle:(NSString*)title
                 withContent:(NSString*)content
                   WithImage:(UIImage*)image;


//+ (void)shareToSinaWeiboByText:(NSString *)text
//                         title:(NSString *)title
//                         image:(id)image
//                           url:(NSURL *)url
//                      latitude:(double)latitude
//                     longitude:(double)longitude
//                      objectID:(NSString *)objectID
//                          type:(SSDKContentType)type;

@end
