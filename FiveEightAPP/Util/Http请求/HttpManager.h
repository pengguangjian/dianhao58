//
//  HttpManager.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/2.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    请求结果
 *
 *    @param isSuccess
 */
typedef void (^ResponseHandler)(id responseObject);

typedef void (^completCallback)(NSURLSessionDataTask * opration, id responceObjct, NSError * error);
typedef void (^completItemback)(NSError *eroor, BOOL state, NSString * desc);

@interface HttpManager : NSObject

@property (nonatomic, copy) ResponseHandler responseHandler;

+ (instancetype)createHttpManager;

/**
 *  http请求 POST
 *
 *  @param transactionDataDic 业务数据 字典 没有为nil
 *  @param interfaceName      接口名称字符串
 *
 *  @return nil 通过实现ResponseHandler Block获取返回数据
 */
- (void)postRequetInterfaceData:(NSDictionary *)transactionDataDic
                  withInterfaceName:(NSString *)interfaceName;

-(void)postRequetInterfaceData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete;
///不需要语言参数
-(void)postRequetInterfaceNoLangData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete;


/**
 *  http请求 get
 *
 *  @param transactionDataDic 业务数据 字典 没有为nil
 *  @param interfaceName      接口名称字符串
 *
 *  @return nil 通过实现ResponseHandler Block获取返回数据
 */
- (void)getRequetInterfaceData:(NSDictionary *)transactionDataDic
             withInterfaceName:(NSString *)interfaceName;

- (void)getRequetInterfaceData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete;


@end
