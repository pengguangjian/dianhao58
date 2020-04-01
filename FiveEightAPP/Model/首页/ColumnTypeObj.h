//
//  ColumnTypeObj.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColumnTypeObj : NSObject
@property(nonatomic, strong) NSNumber* id;//
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *diyname;
@property (nonatomic, copy) NSString *image;
@property(nonatomic, strong) NSNumber* parent_id;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
