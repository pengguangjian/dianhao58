//
//  SearchResultObj.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/26.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultObj : NSObject
@property(nonatomic, strong) NSNumber* id;//
@property(nonatomic, strong) NSNumber* user_id;//
@property(nonatomic, strong) NSNumber* channel_id;//
@property(nonatomic, strong) NSNumber* model_id;//
@property(nonatomic, strong) NSNumber* lang_id;//
@property(nonatomic, strong) NSNumber* city_id;//
@property(nonatomic, strong) NSNumber* area_id;//
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *views;
@end

NS_ASSUME_NONNULL_END
