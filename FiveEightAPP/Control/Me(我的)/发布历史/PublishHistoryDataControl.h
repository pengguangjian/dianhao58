//
//  PublishHistoryDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface PublishHistoryDataControl : NSObject
@property (nonatomic , retain) NSArray *arrList;

///历史发布
-(void)publishHistoryData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///收藏列表
-(void)publishCollectData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///取消收藏
-(void)collectCancleActionData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
