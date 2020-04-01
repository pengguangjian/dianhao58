//
//  ContentDetailDatacontrol.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentDetailDatacontrol : NSObject
///详情
@property (nonatomic , retain) NSDictionary *dicdetail;
///是否收藏
@property (nonatomic , retain) NSString *favoreted;
///评论
@property (nonatomic , retain) NSArray *arrcontent;


///获取详情
-(void)detailData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///获取评论
-(void)contentData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///发布评论
-(void)pushcontentData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///收藏
-(void)collectActionData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///取消收藏
-(void)collectCancleActionData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///删除评论
-(void)delCommentActionData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

@end

NS_ASSUME_NONNULL_END
