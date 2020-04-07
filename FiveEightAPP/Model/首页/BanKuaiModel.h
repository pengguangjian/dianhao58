//
//  BanKuaiModel.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BanKuaiModel : NSObject

@property (nonatomic , retain) NSString *area_name;
@property (nonatomic , retain) NSString *channel_name;
@property (nonatomic , retain) NSString *city_name;
@property (nonatomic , retain) NSString *cover;
@property (nonatomic , retain) NSString *did;
@property (nonatomic , retain) NSString *parent_channel_name;
@property (nonatomic , retain) NSString *publishtime_text;
@property (nonatomic , retain) NSString *title;
@property (nonatomic , retain) NSString *views;
@property (nonatomic , retain) NSString *mobile;
@property (nonatomic , retain) NSArray *image;
@property (nonatomic , retain) NSString *content;
/// 0：未认证，1：个人认证，2：企业商家认证
@property (nonatomic , retain) NSString *authentication_status;
///联系人
@property (nonatomic , retain) NSString *contact;

///normal 正常 verify 审核 rejected 拒绝
@property (nonatomic , retain) NSString *status;

+(BanKuaiModel *)dicToModelValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
