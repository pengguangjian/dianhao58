//
//  PublishDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublishDataControl : NSObject

@property (nonatomic , retain) NSArray *arrlanmuSon;

///获取子栏目数据
-(void)getLanMuSonData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///上传图片
-(void)pushImageData:(NSDictionary *)dicpush andimage:(UIImage *)image andshowView:(UIView *)view Callback:(completItemback)back;

///发布
-(void)pushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
