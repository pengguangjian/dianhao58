//
//  BackgroundTaskManager.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/30.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTaskManager : NSObject

+ (instancetype)sharedBackgroundTaskManager;

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;

@end
