//
//  HomeDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeDataControl : NSObject
@property (nonatomic , retain) NSArray *arrLanMu;
@property (nonatomic , retain) NSArray *arrNewMessage;
@property (nonatomic , retain) NSArray *arrLunBoImage;
@property (nonatomic , retain) NSArray *arrhotLanMu;
@property (nonatomic , retain) NSDictionary *userinfoData;
///获取首页栏目数据
-(void)homeLanMuData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;


-(void)homeNewMessageData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

-(void)homeLunBoImageData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

-(void)hotLanMuData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///用户信息
-(void)userInfoData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
