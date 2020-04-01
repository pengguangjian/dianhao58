//
//  PublishContentObj.h
//  FiveEightAPP
//
//  Created by caochun on 2019/10/12.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FieldsDicObj : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *content;
@end

@interface PublishContentInfoObj : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *lang_id;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *special_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *weigh;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *dislikes;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *extent;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *demand;

@end

@interface PublishContentUserObj : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createtime;
@end

@interface PublishContentObj : NSObject
@property (nonatomic, strong) PublishContentInfoObj *info;
@property (nonatomic, strong) PublishContentUserObj *user;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *langid;
@end

NS_ASSUME_NONNULL_END
