//
//  OpenedCityVC.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/26.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OpenedCityVCHandler)(id cityObj);
typedef void (^OpenedCityVCPublishHandler)(id cityObj, id cityArea);

@interface OpenedCityVC : BaseVC
@property (nonatomic, copy) OpenedCityVCHandler handler;
@property (nonatomic, copy) OpenedCityVCPublishHandler publishHandler;
@property (nonatomic, assign) BOOL isFormPublish;
@end

NS_ASSUME_NONNULL_END
