//
//  ThirePlatformShare.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/2.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "ThirdPlatformShare.h"

#import "SVProgressHUD.h"

@implementation ThirdPlatformShare

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
                   WithImage:(UIImage*)image {
    
    SSDKContentType contentType = SSDKContentTypeAuto;
    if (platformType == SSDKPlatformSubTypeQZone && !content && !urlStr && !title) {
        contentType = SSDKContentTypeImage;
    }
    
    NSURL *url = nil;
    if (urlStr) {
        url = [NSURL URLWithString:urlStr];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:image
                                        url:url
                                      title:title
                                       type:contentType];
    
    
    [SVProgressHUD showWithStatus:@"进行分享"];
    //进行分享
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         // 回调处理....
         
         if (SSDKResponseStateSuccess == state) {
             [SVProgressHUD showSuccessWithStatus:@"分享成功"];
         }
         
         
         if (SSDKResponseStateFail == state) {
             [SVProgressHUD showErrorWithStatus:@"分享失败"];
         }
         
         if (SSDKResponseStateCancel == state) {
             [SVProgressHUD showErrorWithStatus:@"用户取消"];
         }
         
     }];

    
}


//+ (void)shareToSinaWeiboByText:(NSString *)text
//                         title:(NSString *)title
//                         image:(id)image
//                           url:(NSURL *)url
//                      latitude:(double)latitude
//                     longitude:(double)longitude
//                      objectID:(NSString *)objectID
//                          type:(SSDKContentType)type {
//    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:(NSString *)text
//                                               title:(NSString *)title
//                                               image:(id)image
//                                                 url:(NSURL *)url
//                                            latitude:(double)latitude
//                                           longitude:(double)longitude
//                                            objectID:(NSString *)objectID
//                                                type:(SSDKContentType)type];
//    
//    
//    //进行分享
//    [ShareSDK share:SSDKPlatformTypeSinaWeibo //传入分享的平台类型
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         // 回调处理....
//         
//         if (SSDKResponseStateSuccess == state) {
//             [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//         }
//         
//         if (SSDKResponseStateFail == state) {
//             [SVProgressHUD showErrorWithStatus:@"分享失败"];
//         }
//         
//         if (SSDKResponseStateCancel == state) {
//             [SVProgressHUD showErrorWithStatus:@"用户取消"];
//         }
//         
//     }];
//    
//    
//    
//    
//}



@end
