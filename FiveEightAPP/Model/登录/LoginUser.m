//
//  LoginUser.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "LoginUser.h"



@implementation LoginUser


-(void)saveUser
{
    //保存用户信息
    [User sharedUser].user_id = [self.user_id stringValue];
    [User sharedUser].token = self.token;
    [User sharedUser].nickname = self.nickname;
    [User sharedUser].sex = self.gender;
    [User sharedUser].phone = self.mobile;
    [User sharedUser].headImage = self.avatar;
    [User sharedUser].linksys = self.linksys;
    [User sharedUser].brithday = self.birthday;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
