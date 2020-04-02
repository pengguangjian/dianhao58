//
//  LoginDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginDataControl : NSObject
@property (nonatomic , retain) NSDictionary *dicLogin;
@property (nonatomic , retain) NSDictionary *dicResign;
@property (nonatomic , retain) NSDictionary *dicOtherLogin;
@property (nonatomic , retain) NSDictionary *dicOtherLoginBD;
@property (nonatomic , retain) NSDictionary *dicLoginPhone;
@property (nonatomic , retain) NSDictionary *dicPhoneIs;
///登录
-(void)loginPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;
///第三方登录
-(void)otherLoginPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///手机号登录
-(void)loginPhonePushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

//判断账号是否存在
-(void)phoneIsAccountPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///第三方绑定
-(void)otherLoginBangDingPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///注册
-(void)resignPushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///重置密码
-(void)resetpwdData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
