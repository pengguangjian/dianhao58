//
//  ResponseData.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/14.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseData : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *sub_code;
@property (nonatomic, copy) NSString *sub_msg;
@end
