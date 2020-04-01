//
//  LocationTracker.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "LocationTracker.h"

@interface LocationTracker() {
    AMapLocationManager *locationManager;
    AMapSearchAPI *aMapSearchAPI;
    
    int runTimes;
}
@end

@implementation LocationTracker

+ (instancetype)sharedLocationManager {
    
    static dispatch_once_t once;
    static LocationTracker *locationTracker;
    dispatch_once(&once, ^ {
        locationTracker = [[self alloc] init];
        
        [locationTracker initLocationManager];
        
//        locationTracker.adCode = @"500112";//默认区域
        
    });
    
    return locationTracker;
}

- (void)initLocationManager {
    if (!locationManager) {
        locationManager = [[AMapLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setPausesLocationUpdatesAutomatically:NO];
        [locationManager setAllowsBackgroundLocationUpdates:YES];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        locationManager.distanceFilter = 5.0f;  //5m刷新
        
        aMapSearchAPI = [[AMapSearchAPI alloc] init];
        aMapSearchAPI.delegate = self;
        
        self.shareModel = [LocationShareModel sharedModel];
        
        self.shareModel.locationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    
}

- (void)startLocationTracking {
    //开始定位
    
    [locationManager startUpdatingLocation];
    
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                           selector:@selector(applicationEnterBackground)
                                                           userInfo:nil
                                                            repeats:YES];
}

- (void)stopLocationTracking {
    //停止定位
    [locationManager stopUpdatingLocation];
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
}

-(void)applicationEnterBackground {
    
//    if ([[User sharedUser].workstatus intValue] == 0) {
//        [self stopLocationTracking];
//        return;
//    }

    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setPausesLocationUpdatesAutomatically:NO];
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 5.0f;  //5m刷新
    [locationManager startUpdatingLocation];
    
    aMapSearchAPI = [[AMapSearchAPI alloc] init];
    aMapSearchAPI.delegate = self;
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTaskManager = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTaskManager beginNewBackgroundTask];
    
    runTimes++;
    if (runTimes%6 == 0) {
        [self updateLocToService];
    }
}


- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
    
    _coordinate =  location.coordinate;
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:_coordinate.latitude longitude:_coordinate.longitude];
    regeo.requireExtension            = YES;
    [aMapSearchAPI AMapReGoecodeSearch:regeo];
}

#pragma mark -- AMapSearchDelegate 地址解析处理

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    AMapReGeocode *aMapReGeocode = response.regeocode;
    AMapAddressComponent *addressComponent = aMapReGeocode.addressComponent;
    
    AMapRoad *road = [aMapReGeocode.roads firstObject];
    AMapRoadInter *roadInter = [aMapReGeocode.roadinters firstObject];
    AMapPOI *poi = [aMapReGeocode.pois firstObject];
    AMapPOI *aoi = [aMapReGeocode.aois firstObject];
//    NSLog(@"%@",aMapReGeocode.formattedAddress);
    
    
    _addressComponent = addressComponent;
    
    _adCode = addressComponent.adcode;
    
    _citycode = addressComponent.citycode;
    
    
    NSString *addrInfo = @"";
    if(addressComponent.city) {
        addrInfo = [addrInfo stringByAppendingString:addressComponent.city];
    }
    if(addressComponent.district) {
        addrInfo = [addrInfo stringByAppendingString:addressComponent.district];
    }
    if(addressComponent.township) {
        addrInfo = [addrInfo stringByAppendingString:addressComponent.township];
    }
    
    
    if (self.locationTrackerHandler) {
        self.locationTrackerHandler(addrInfo, addressComponent.city, addressComponent.district);
    }
    
//    [self stopLocationTracking];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

#pragma mark -

- (void)updateLocToService {
    
    HttpManager *hm = [HttpManager createHttpManager];
    
    hm.responseHandler = ^(id responseObject) {
        
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS]) {
            
//            NSLog(@"");
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD showErrorWithStatus:rd.msg];
            });
        }
    };
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[NSNumber numberWithDouble:_coordinate.latitude] forKey:@"lat"];
    [dataDic setValue:[NSNumber numberWithDouble:_coordinate.longitude] forKey:@"lng"];
    
    [hm postRequetInterfaceData:dataDic withInterfaceName:@"user/usergps"];
    
}

@end
