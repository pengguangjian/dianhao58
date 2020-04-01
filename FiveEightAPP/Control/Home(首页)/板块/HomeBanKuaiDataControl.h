//
//  HomeBanKuaiDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeBanKuaiDataControl : NSObject
@property (nonatomic , retain) NSArray *arrLanMuItemList;
@property (nonatomic , retain) NSArray *arrhomesearchLis;
///获取栏目列表数据
-(void)homeLanMuItemListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;

///搜索列表数据
-(void)homesearchListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;


@end

NS_ASSUME_NONNULL_END
