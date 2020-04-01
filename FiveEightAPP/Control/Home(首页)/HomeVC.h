//
//  HomeVC.h
//  FiveEight
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "BaseVC.h"
#import "OpenedCity.h"

@interface HomeVC : BaseVC

@property(nonatomic,strong) NSMutableArray *typeArr;
@property(nonatomic,strong) OpenedCity *oc;
@end
