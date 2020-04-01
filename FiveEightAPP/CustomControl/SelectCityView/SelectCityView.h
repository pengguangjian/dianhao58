//
//  SelectCityView.h
//  GuoHuiAPP
//
//  Created by caochun on 2016/10/30.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SelectCityHandler)(NSString *lastAddr, NSNumber *pro_id, NSNumber *city_id, NSNumber *area_id);

@interface SelectCityView : UIView

@property (strong, nonatomic) NSArray *cityList;//json解析数组

@property (strong, nonatomic) NSArray *provArray;//省份名称数组
@property (strong, nonatomic) NSArray *cityArray;//城市名称数组
@property (strong, nonatomic) NSArray *areaArray;//区名称数组

@property (strong, nonatomic) NSArray *pro_idArray;//省份id数组
@property (strong, nonatomic) NSArray *city_idArray;//城市id数组
@property (strong, nonatomic) NSArray *area_idArray;//区id数组

@property (strong, nonatomic) NSString *lastAdd;//所选择的省市区

@property (strong, nonatomic) NSString *addString;

@property (nonatomic, copy) SelectCityHandler selectCityHandler;

/**
 *  创建单例并绘制界面
 *
 *  @return return value instancetype
 */
+ (instancetype)sharedView;
- (void)show;

@end
