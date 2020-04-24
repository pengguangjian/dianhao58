//
//  HttpManager.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/2.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"

@implementation HttpManager

+ (instancetype)createHttpManager {
    
    return [[HttpManager alloc] init];
}

- (void)postRequetInterfaceData:(NSDictionary *)transactionDataDic
                   withInterfaceName:(NSString *)interfaceName {
    
    //将业务数据的字典转化为Json串
    NSString *dataStr = nil;
    if (transactionDataDic) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transactionDataDic
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        dataStr = [[NSString alloc]initWithData:jsonData
                                       encoding:NSUTF8StringEncoding];
    }
    
    //URL组拼
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, interfaceName];
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加可接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    
    if ([User sharedUser].token.length>0) {
        [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"token"];
    }
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    if([userSettingLanguage isEqualToString:@"vi"])
     {
         [manager.requestSerializer setValue:@"vn" forHTTPHeaderField:@"lang"];
     }
     else
     {
         [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"lang"];
     }
    
//    if ([User sharedUser].access_token.length>0) {
//        [manager.requestSerializer setValue:[User sharedUser].access_token forHTTPHeaderField:@"access-token"];
//    }
    [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (dataStr) {
        NSLog(@"%@  %@",interfaceName, dataStr);
        [parameters setObject:dataStr forKey:@"data"];
    } else {
        parameters = nil;
    }
    
    [manager POST:URL.absoluteString parameters:transactionDataDic progress:^(NSProgress *uploadProgress) {
        //正在执行请求
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:UNLOGIN]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self logout];
                [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            });
            
        } else {
            
            if (self.responseHandler) {
                self.responseHandler(responseObject);
            }
            
        }

        NSLog(@"success %@",interfaceName);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"failure %@",interfaceName);

     }];
}

-(void)postRequetInterfaceData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete
{
//    //将业务数据的字典转化为Json串
//    NSString *dataStr = nil;
//    if (transactionDataDic) {
//
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transactionDataDic
//                                                           options:NSJSONWritingPrettyPrinted error:nil];
//        dataStr = [[NSString alloc]initWithData:jsonData
//                                       encoding:NSUTF8StringEncoding];
//    }
    
    //URL组拼
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, interfaceName];
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加可接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    
    if ([User sharedUser].token.length>0) {
        [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"token"];
    }
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    if([userSettingLanguage isEqualToString:@"vi"])
     {
         [manager.requestSerializer setValue:@"vn" forHTTPHeaderField:@"lang"];
     }
     else
     {
         [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"lang"];
     }
    [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
    
    
    if([interfaceName isEqualToString:@"frontend.Attestation/addAttestationPeople"])
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
        
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:transactionDataDic];
//    if (dataStr) {
//        NSLog(@"%@  %@",interfaceName, dataStr);
//        [parameters setObject:dataStr forKey:@"data"];
//    } else {
//        parameters = nil;
//    }
    if (!([userSettingLanguage isEqualToString:@"zh-Hans"]||
        [userSettingLanguage isEqualToString:@"vi"])) {
        userSettingLanguage = @"zh-Hans";
    }
    
   if([userSettingLanguage isEqualToString:@"zh-Hans"])
    {
        [parameters setObject:@"zh-cn" forKey:@"lang"];
        [parameters setObject:@"zh-cn" forKey:@"lang_id"];
    }
    else if([userSettingLanguage isEqualToString:@"vi"])
    {
        [parameters setObject:@"vn" forKey:@"lang"];
        [parameters setObject:@"vn" forKey:@"lang_id"];
    }
    else
    {
        [parameters setObject:userSettingLanguage forKey:@"lang"];
        [parameters setObject:userSettingLanguage forKey:@"lang_id"];
    }
    
    [manager POST:URL.absoluteString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:UNLOGIN]) {
            ///登录失效
            dispatch_async(dispatch_get_main_queue(), ^{
                [self logout];
                [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            });
            
        } else {
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            complete(task,responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        complete(task,nil,error);
    }];
    
    
}

///不需要语言参数
-(void)postRequetInterfaceNoLangData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete
{
    
     //URL组拼
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, interfaceName];
        NSURL *URL = [NSURL URLWithString:urlStr];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //添加可接受数据类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
        manager.requestSerializer.timeoutInterval = 15.0f;
        
        
        if ([User sharedUser].token.length>0) {
            [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"token"];
        }
        NSString *userSettingLanguage = [NSBundle currentLanguage];
        if([userSettingLanguage isEqualToString:@"vi"])
         {
             [manager.requestSerializer setValue:@"vn" forHTTPHeaderField:@"lang"];
         }
         else
         {
             [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"lang"];
         }
        [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
        
        
//        if([interfaceName isEqualToString:@"frontend.Attestation/addAttestationPeople"])
//        {
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        }
            
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:transactionDataDic];
        
    
    
    
        [manager POST:URL.absoluteString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:UNLOGIN]) {
                ///登录失效
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self logout];
                    [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
                });
                
            } else {
                responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                complete(task,responseObject,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            complete(task,nil,error);
        }];
    
}



- (void)getRequetInterfaceData:(NSDictionary *)transactionDataDic
              withInterfaceName:(NSString *)interfaceName {
    
    //将业务数据的字典转化为Json串
    NSString *dataStr = nil;
    if (transactionDataDic) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transactionDataDic
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        dataStr = [[NSString alloc]initWithData:jsonData
                                       encoding:NSUTF8StringEncoding];
    }
    
    //URL组拼
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, interfaceName];
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加可接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    

    if ([User sharedUser].token.length>0) {
        [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"token"];
    }
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    if([userSettingLanguage isEqualToString:@"vi"])
     {
         [manager.requestSerializer setValue:@"vn" forHTTPHeaderField:@"lang"];
     }
     else
     {
         [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"lang"];
     }
    [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (dataStr) {
        NSLog(@"%@  %@",interfaceName, dataStr);
        [parameters setObject:dataStr forKey:@"data"];
    } else {
        parameters = nil;
    }
    
    
    
    [manager GET:URL.absoluteString parameters:transactionDataDic progress:^(NSProgress *uploadProgress) {
        //正在执行请求
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:UNLOGIN]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self logout];
                [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            });
            
        } else {
            
            if (self.responseHandler) {
                self.responseHandler(responseObject);
            }
            
        }
        
        NSLog(@"success %@",interfaceName);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"failure %@",interfaceName);
        
    }];
}
- (void)getRequetInterfaceData:(NSDictionary *)transactionDataDic
withInterfaceName:(NSString *)interfaceName andresponseHandler:(completCallback)complete
{
//    //将业务数据的字典转化为Json串
//    NSString *dataStr = nil;
//    if (transactionDataDic) {
//
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transactionDataDic
//                                                           options:NSJSONWritingPrettyPrinted error:nil];
//        dataStr = [[NSString alloc]initWithData:jsonData
//                                       encoding:NSUTF8StringEncoding];
//    }
    
    //URL组拼
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, interfaceName];
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加可接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    

    if ([User sharedUser].token.length>0) {
        [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"token"];
    }
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    if([userSettingLanguage isEqualToString:@"vi"])
     {
         [manager.requestSerializer setValue:@"vn" forHTTPHeaderField:@"lang"];
     }
     else
     {
         [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"lang"];
     }
    [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:transactionDataDic];
//    if (dataStr) {
//        NSLog(@"%@  %@",interfaceName, dataStr);
//        [parameters setObject:dataStr forKey:@"data"];
//    } else {
//        parameters = nil;
//    }
    
    if (!([userSettingLanguage isEqualToString:@"zh-Hans"]||
        [userSettingLanguage isEqualToString:@"vi"])) {
        userSettingLanguage = @"zh-Hans";
    }
    
    if([userSettingLanguage isEqualToString:@"zh-Hans"])
    {
        [parameters setObject:@"zh-cn" forKey:@"lang"];
        
        [parameters setObject:@"zh-cn" forKey:@"lang_id"];
    }
    else if([userSettingLanguage isEqualToString:@"vi"])
    {
        [parameters setObject:@"vn" forKey:@"lang"];
        [parameters setObject:@"vn" forKey:@"lang_id"];
    }
    else
    {
        [parameters setObject:userSettingLanguage forKey:@"lang"];
        [parameters setObject:userSettingLanguage forKey:@"lang_id"];
    }
    
    
    
    
    [manager GET:URL.absoluteString parameters:parameters progress:^(NSProgress *uploadProgress) {
        //正在执行请求
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:UNLOGIN]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self logout];
                [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            });
            
        } else {
            
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            complete(task,responseObject,nil);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        complete(task,nil,error);
    }];
}



- (void)showToast {
    [SVProgressHUD showErrorWithStatus:@"账号已在其他地方登录"];
}


- (void)logout {
    
//    if ([User isNeedLogin]) {
//        return;
//    }
//    
//    [[Util topViewController].navigationController popToRootViewControllerAnimated:NO];
//    //返回首页
//    UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
//    [tabBar setSelectedIndex:0];
//    
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"删除推送别名");
//    } seq:0];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenPush"];
//    
//    [User clearUser];
//    
//    [self performSelector:@selector(callLoginVC) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
    
}

- (void)callLoginVC {
    [Util LoginVC:YES];
}

@end
