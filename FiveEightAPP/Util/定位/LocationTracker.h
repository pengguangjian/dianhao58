//
//  LocationTracker.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "LocationShareModel.h"

typedef void (^LocationTrackerHandler)(NSString *addrInfo, NSString *city, NSString *area);


@interface LocationTracker : NSObject

@property (nonatomic, strong) AMapAddressComponent *addressComponent;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *citycode;
@property (nonatomic, copy) NSString *adCode;
@property (nonatomic, assign) BOOL isModifyAdCode;

@property (nonatomic, copy) LocationTrackerHandler locationTrackerHandler;

@property (strong,nonatomic) LocationShareModel *shareModel;

+ (instancetype)sharedLocationManager;
- (void)startLocationTracking;
- (void)stopLocationTracking;
//- (void)updateLocationToServer;
@end
