//
//  PersonalInfoDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalInfoDataControl : NSObject

///上传图片
-(void)pushImageData:(NSDictionary *)dicpush andimage:(UIImage *)image andshowView:(UIView *)view Callback:(completItemback)back;

///修改用户信息
-(void)changeUserInfoData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
