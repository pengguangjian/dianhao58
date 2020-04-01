//
//  OpenedCity.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/26.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenedCity : NSObject
@property(nonatomic, strong) NSNumber* id;//
@property(nonatomic, strong) NSNumber* hot;//
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *seotitle;

@end

NS_ASSUME_NONNULL_END
