//
//  LocationShareModel.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/30.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import "BackgroundTaskManager.h"

@interface LocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *delay10Seconds;
@property (nonatomic) BackgroundTaskManager * bgTaskManager;
@property (nonatomic) NSMutableArray *locationArray;

+ (id)sharedModel;

@end
