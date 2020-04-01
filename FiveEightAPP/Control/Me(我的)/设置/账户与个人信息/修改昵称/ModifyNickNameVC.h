//
//  ModifyNickNameVC.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "BaseVC.h"

typedef void (^ModifyHandler)(NSString *nickName);

@interface ModifyNickNameVC : BaseVC
@property (nonatomic, copy) NSString *nickName;//修改前的昵称
@property (nonatomic, assign) BOOL isRegister;//YES注册 不需要保存 NO需要保存
@property (nonatomic, copy) ModifyHandler modifyHandler;

@end
