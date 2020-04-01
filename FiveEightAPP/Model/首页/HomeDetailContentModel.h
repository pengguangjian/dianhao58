//
//  HomeDetailContentModel.h
//  FiveEightAPP
//  文章评论model
//  Created by Mac on 2020/3/28.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDetailContentModel : NSObject
@property (nonatomic , retain) NSString *did;
@property (nonatomic , retain) NSString *content;
@property (nonatomic , retain) NSString *user_id;
@property (nonatomic , retain) NSString *create_date;
@property (nonatomic , retain) NSString *userinfoid;
@property (nonatomic , retain) NSString *userinfonickname;
@property (nonatomic , retain) NSString *userinfoavatar;
@property (nonatomic , retain) NSString *touserid;
@property (nonatomic , retain) NSString *tousernickname;
@property (nonatomic , retain) NSString *touseravatar;
///是否是回复
@property (nonatomic , assign) BOOL ishuifu;


+(HomeDetailContentModel *)dicToModelValue:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
