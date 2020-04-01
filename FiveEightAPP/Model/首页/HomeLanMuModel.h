//
//  HomeLanMuModel.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeLanMuModel : NSObject

@property (nonatomic , retain) NSString *did;
@property (nonatomic , retain) NSString *flag;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *diyname;
@property (nonatomic , retain) NSString *image;
@property (nonatomic , retain) NSString *parent_id;
@property (nonatomic , retain) NSString *type;
@property (nonatomic , retain) NSString *keywords;
@property (nonatomic , retain) NSString *desc;
@property (nonatomic , retain) NSString *channeltpl;
@property (nonatomic , retain) NSString *listtpl;
@property (nonatomic , retain) NSString *showtpl;
@property (nonatomic , retain) NSMutableArray *arrson;

+(HomeLanMuModel *)dicToModelValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
