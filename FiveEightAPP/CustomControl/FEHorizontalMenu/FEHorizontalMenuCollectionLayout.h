//
//  FEHorizontalMenuCollectionLayout.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEHorizontalMenuCollectionLayout : UICollectionViewLayout

@property (nonatomic,assign) NSInteger rowCount;

@property (nonatomic,assign) NSInteger columCount;


/**
 获取当前页数
 
 @return 页数
 */
- (NSInteger)currentPageCount;

@end
