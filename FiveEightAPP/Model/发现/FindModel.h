//
//  FindModel.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindModel : NSObject

@property (nonatomic , retain) NSString *thumb;
@property (nonatomic , retain) NSString *title;
@property (nonatomic , retain) NSString *updatetime;
@property (nonatomic , retain) NSString *url;


+(FindModel *)dicModelValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
