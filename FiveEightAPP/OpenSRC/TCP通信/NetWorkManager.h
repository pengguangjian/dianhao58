//
//  NetWorkManager.h
//  GCDAsyncSocket
//
//  Created by caochun on 17/5/25.
//  Copyright © 2017年 caochun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetWorkDidChangeNotification @"NetWorkDidChangeNotification"    // 网络状态变化通知

// 网络状态管理
@interface NetWorkManager : NSObject

+ (NetWorkManager *)instance;

- (void)startListen;
- (void)stopListen;
- (BOOL)status;

@end
