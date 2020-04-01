//
//  LoginUser.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LoginUser : NSObject
@property(nonatomic, copy) NSString* email;
@property(nonatomic, copy) NSString* mobile;
@property(nonatomic, copy) NSString* avatar;
@property(nonatomic, strong) NSNumber* gender;
@property(nonatomic, copy) NSString* username;
@property(nonatomic, copy) NSString* nickname;
@property(nonatomic, strong) NSNumber* user_id;
@property(nonatomic, strong) NSNumber* id;
@property(nonatomic, strong) NSNumber* group_id;
@property(nonatomic, copy) NSString* birthday;
@property(nonatomic, copy) NSString* expires_in;
@property(nonatomic, copy) NSString* createtime;
@property(nonatomic, copy) NSString* logintime;
@property(nonatomic, strong) NSNumber* score;
@property(nonatomic, copy) NSString* expiretime;
@property(nonatomic, copy) NSString* token;
@property(nonatomic, strong) NSString *linksys;
-(void)saveUser;

@end

NS_ASSUME_NONNULL_END
