//
//  User.h
//  TechnicianAPP
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic,copy) NSString* user_id;
@property(nonatomic,copy) NSString* token;
@property(nonatomic, copy) NSString* nickname;
@property(nonatomic, strong) NSNumber* sex;//性别 0:未设置 1:男 2:女
@property(nonatomic, copy) NSString* phone;
@property(nonatomic, copy) NSString* headImage;
@property(nonatomic, copy) NSString* create_date;
@property(nonatomic, copy) NSString* platform;
@property(nonatomic, copy) NSString* brithday;
@property(nonatomic, strong) NSNumber* userType;//用户类型
@property(nonatomic, strong) NSNumber* userStatus;//用户状态 1:启用 2:禁用
@property(nonatomic, strong) NSNumber* isSetLoginPwd;//是否设置登录密码
@property(nonatomic, strong) NSNumber* isSetPayPwd;//是否设置支付密码
@property(nonatomic, strong) NSNumber* coupon;//用户卡券
@property(nonatomic, strong) NSNumber* score;//用户积分
@property(nonatomic, strong) NSNumber* money;//用户米袋
@property (nonatomic, copy) NSNumber *isBindQQ;//是否绑定QQ
@property (nonatomic, copy) NSNumber *isBindWX;//是否绑定微信
@property (nonatomic, copy) NSNumber *isBindWB;//是否绑定微博

@property (nonatomic,copy) NSString* access_token;
@property (nonatomic, strong) NSNumber *countSell;
@property (nonatomic, strong) NSNumber *cumulative;
@property (nonatomic, strong) NSNumber *totalCommission;
@property (nonatomic, strong) NSNumber *countCoupon;
@property (nonatomic, strong) NSNumber *balance;
///客服电话
@property (nonatomic,copy) NSString* linksys;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;


+ (instancetype)sharedUser;

/**
 *  获取本地User对象并更新
 *
 *  @param user User
 */
+ (void)updateUser:(User*)user;

/**
 *  清除本地User对象
 *
 */
+ (void)clearUser;

/**
 *  判断是否第三方登录
 *
 *  @return BOOL YES:第三方登录 NO：正常用户/未登录
 */
+ (BOOL)isThirdPlatformLogin;

/**
 *  判断是否游客登录
 *
 *  @return BOOL YES:游客 NO：正常用户/未登录
 */
+ (BOOL)isTouristLogin;

/**
 *  判断是否需要登录
 *
 *  @return BOOL
 */
+ (BOOL)isNeedLogin;

@end
