//
//  User.m
//  TechnicianAPP
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "User.h"
#import <objc/runtime.h>

@implementation User
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}


+ (instancetype)sharedUser {
    static dispatch_once_t onceToken;
    static User *instance;
    dispatch_once(&onceToken, ^{
        instance = [[User alloc] init];
    });
    return instance;
}

+ (void)updateUser:(User*)user {
    
    if (!user) {
        [User sharedUser].user_id = nil;
        [User sharedUser].token = nil;
        [User sharedUser].nickname = nil;
        [User sharedUser].sex = nil;
        [User sharedUser].phone = nil;
        [User sharedUser].headImage = nil;
        [User sharedUser].create_date = nil;
        [User sharedUser].platform = nil;
        [User sharedUser].brithday = nil;
        [User sharedUser].userType = nil;
        [User sharedUser].userStatus = nil;
        [User sharedUser].isSetLoginPwd = nil;
        [User sharedUser].isSetPayPwd = nil;
        [User sharedUser].coupon = nil;
        [User sharedUser].score = nil;
        [User sharedUser].money = nil;
        [User sharedUser].isBindQQ = nil;
        [User sharedUser].isBindWX = nil;
        [User sharedUser].isBindWB = nil;
        
        [User sharedUser].access_token = nil;
        [User sharedUser].cumulative = nil;
        [User sharedUser].totalCommission = nil;
        [User sharedUser].countCoupon = nil;
        [User sharedUser].balance = nil;
        [User sharedUser].linksys = nil;
        
    } else {
        [User sharedUser].user_id = user.user_id;
        [User sharedUser].token = user.token;
        [User sharedUser].nickname = user.nickname;
        [User sharedUser].sex = user.sex;
        [User sharedUser].phone = user.phone;
        [User sharedUser].headImage = user.headImage;
        [User sharedUser].create_date = user.create_date;
        [User sharedUser].platform = user.platform;
        [User sharedUser].brithday = user.brithday;
        [User sharedUser].userType = user.userType;
        [User sharedUser].userStatus = user.userStatus;
        [User sharedUser].isSetLoginPwd = user.isSetLoginPwd;
        [User sharedUser].isSetPayPwd = user.isSetPayPwd;
        [User sharedUser].coupon = user.coupon;
        [User sharedUser].score = user.score;
        [User sharedUser].money = user.money;
        [User sharedUser].isBindQQ = user.isBindQQ;
        [User sharedUser].isBindWX = user.isBindWX;
        [User sharedUser].isBindWB = user.isBindWB;
        
        [User sharedUser].access_token = user.access_token;
        [User sharedUser].cumulative = user.cumulative;
        [User sharedUser].totalCommission = user.totalCommission;
        [User sharedUser].countCoupon = user.countCoupon;
        [User sharedUser].balance = user.balance;
        [User sharedUser].linksys = user.linksys;
    }
    
}

+ (void)clearUser {
    
    [User sharedUser].user_id = nil;
    [User sharedUser].token = nil;
    [User sharedUser].nickname = nil;
    [User sharedUser].sex = nil;
    [User sharedUser].phone = nil;
    [User sharedUser].headImage = nil;
    [User sharedUser].create_date = nil;
    [User sharedUser].platform = nil;
    [User sharedUser].brithday = nil;
    [User sharedUser].userType = nil;
    [User sharedUser].userStatus = nil;
    [User sharedUser].isSetLoginPwd = nil;
    [User sharedUser].isSetPayPwd = nil;
    [User sharedUser].coupon = nil;
    [User sharedUser].score = nil;
    [User sharedUser].money = nil;
    [User sharedUser].isBindQQ = nil;
    [User sharedUser].isBindWX = nil;
    [User sharedUser].isBindWB = nil;

    [User sharedUser].access_token = nil;
    [User sharedUser].cumulative = nil;
    [User sharedUser].totalCommission = nil;
    [User sharedUser].countCoupon = nil;
    [User sharedUser].balance = nil;
    [User sharedUser].linksys = nil;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)isThirdPlatformLogin {
    
    if ([User sharedUser].nickname && [User sharedUser].nickname.length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTouristLogin
{
    
    if ([User sharedUser].nickname && [User sharedUser].nickname.length > 0) {
        return NO;
    }

    if ([User sharedUser].user_id && [User sharedUser].user_id.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isNeedLogin
{
    if ([User sharedUser].token && [User sharedUser].token.length > 0) {
        return NO;
    }
    return YES;
}
@end
