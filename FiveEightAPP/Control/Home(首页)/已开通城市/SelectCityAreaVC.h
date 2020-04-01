//
//  SelectCityAreaVC.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "BaseVC.h"
#import "OpenedCity.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectCityAreaVCHandler)(id cityAreaObj);
@interface SelectCityAreaVC : BaseVC
@property (nonatomic, copy) SelectCityAreaVCHandler handler;
@property (nonatomic, strong) OpenedCity *oc;
@property (nonatomic, assign) BOOL isFormPublish;
@end

NS_ASSUME_NONNULL_END
