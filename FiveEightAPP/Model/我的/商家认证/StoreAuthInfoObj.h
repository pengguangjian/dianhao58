//
//  StoreAuthInfoObj.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/30.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreAuthInfoObj : NSObject
@property(nonatomic, strong) NSNumber* id;
@property(nonatomic, strong) NSNumber* user_id;
@property(nonatomic, strong) NSNumber* city_id;
@property(nonatomic, strong) NSNumber* type;
@property(nonatomic, copy) NSString* mobile;
@property(nonatomic, copy) NSString* contact;
@property(nonatomic, copy) NSString* company;
@property(nonatomic, copy) NSString* bankname;
@property(nonatomic, copy) NSString* banknum;
@property(nonatomic, strong) NSNumber* bankverify;
@property(nonatomic, copy) NSString* legalname;
@property(nonatomic, copy) NSString* legalimg;
@property(nonatomic, copy) NSString* legalnum;
@property(nonatomic, strong) NSNumber* legalverify;
@property(nonatomic, copy) NSString* license;
@property(nonatomic, strong) NSNumber* licenseverify;
@property(nonatomic, copy) NSString* team;
@property(nonatomic, strong) NSNumber* score;
@property(nonatomic, strong) NSNumber* money;
@property(nonatomic, strong) NSNumber* status;
@property(nonatomic, copy) NSString* passtime;
@property(nonatomic, copy) NSString* ip;
@property(nonatomic, copy) NSString* applytime;
@end

NS_ASSUME_NONNULL_END
