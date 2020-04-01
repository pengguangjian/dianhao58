//
//  FEClassifyCollectionView.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FEClassifyCollectionViewDelegate <NSObject>

-(void)selectItemValue:(id)value;

@end

@interface FEClassifyCollectionView : UIView
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic,weak)id<FEClassifyCollectionViewDelegate>delegate;

@end
