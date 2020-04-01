//
//  StoreSuthDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/30.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface StoreSuthDataControl : NSObject
@property (nonatomic , retain) NSDictionary *dicSuth;

///上传图片
-(void)pushImageData:(NSDictionary *)dicpush andimage:(UIImage *)image andshowView:(UIView *)view Callback:(completItemback)back;

///我的认证状态
-(void)storeSuthData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///个人认证
-(void)attestationPeopleData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///企业认证
-(void)qiyeData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
