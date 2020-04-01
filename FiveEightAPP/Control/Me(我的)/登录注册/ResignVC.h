//
//  ResignVC.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResignVC : BaseVC

///第三方绑定
@property (nonatomic ,retain) NSDictionary *dicBangDing;
@property (nonatomic , assign) BOOL isbangding;
@property (nonatomic ,retain) NSString *strnickname;
@end

NS_ASSUME_NONNULL_END
