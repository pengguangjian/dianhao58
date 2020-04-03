//
//  Util.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString*)getSmallImageUrlStr:(NSString*)originalUrl withWidth:(int)w withHeight:(int)h;

+ (NSString*)getUDID;

+ (UIViewController *)topViewController;

+ (void)LoginVC:(BOOL)animated;

+ (void)changeRootVC;

+ (NSString *)time_timestampToString:(double)timestamp;
+ (NSString *)dateTimeToString:(double)timestamp;
+ (NSString *)time_DatestampToString:(double)timestamp;
+ (NSString *)time_timestampToStr:(double)timestamp;

+ (NSInteger)getIntervalDay:(NSDate*)sDate withEndDate:(NSDate*)eDate;

// 根据颜色生成UIImage
+ (UIImage*)imageWithColor:(UIColor*)color;

//+ (NSMutableArray *)getShoppingCartDataArr;
//
//+ (void)saveShoppingCartDataArr:(NSMutableArray *)arr;

/**
 *  验证验证码的合法性
 *
 *  @param vCode 验证码
 *
 *  @return BOOL
 */
+ (BOOL)validateVCode:(NSString*)vCode;

/**
 *  验证电话号码的合法性
 *
 *  @param mobileNum 电话号码
 *
 *  @return BOOL
 */
+(BOOL)validateMobile:(NSString *)mobileNum;

// 隐藏手机号中间4位
+ (NSString *)getConcealPhoneNumber:(NSString *)phoneNum;

// 获得应用版本号
+ (NSString *)getApplicationVersion;

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard;
/**
 *  MD5加密
 *
 *  @param input NSString
 *
 *  @return NSString
 */
+ (NSString *)MD5Digest:(NSString *)input;

/**
 *  View生成Image
 *
 *  @param view UIView
 *
 *  @return UIImage
 */
+ (UIImage *)makeImageWithView:(UIView *)view;

/**
 *  设置导航栏背景颜色和是否隐藏分割线
 *
 *  @param nav    UINavigationBar
 *  @param color  UIColor
 *  @param isHidden BOOL YES：隐藏 NO：显示
 */
+ (void)setNavigationBar:(UINavigationBar*)nav andBackgroundColor:(UIColor*)color andIsShowSplitLine:(BOOL)isHidden;


+ (NSDictionary*)getObjectData:(id)obj;

+ (NSString *)formatFloat:(float)f;

//利用CCRandomGenerateBytes实现随机字符串的生成
+ (NSString *)randomString:(NSInteger)length;

//当前时间戳
+ (NSString *)currentDateInterval;

+ (NSString *)dicToMD5Str:(NSDictionary*)dic;

//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str;


@end
