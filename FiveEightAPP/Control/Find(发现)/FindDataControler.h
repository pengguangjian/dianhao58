//
//  FindDataControler.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface FindDataControler : NSObject
@property (nonatomic , retain) NSArray *arrList;

///
-(void)findListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;


@end

NS_ASSUME_NONNULL_END
