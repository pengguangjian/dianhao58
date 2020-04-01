//
//  CollectListObj.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectListObj : NSObject
@property(nonatomic, strong) NSNumber* id;//
@property(nonatomic, strong) NSNumber* user_id;//
@property(nonatomic, strong) NSNumber* channel_id;//
@property(nonatomic, strong) NSNumber* model_id;//
@property(nonatomic, strong) NSNumber* lang_id;//
@property(nonatomic, strong) NSNumber* city_id;//
@property(nonatomic, strong) NSNumber* area_id;//
@property(nonatomic, strong) NSNumber* special_id;//
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *tags;
@property(nonatomic, strong) NSNumber* weigh;
@property(nonatomic, strong) NSNumber* views;
@property(nonatomic, strong) NSNumber* comments;
@property(nonatomic, strong) NSNumber* likes;
@property(nonatomic, strong) NSNumber* dislikes;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *diyname;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *publishtime;
@property (nonatomic, copy) NSString *deletetime;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *status;
@property(nonatomic, strong) NSNumber* article_id;
@end

NS_ASSUME_NONNULL_END
