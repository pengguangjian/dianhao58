//
//  MyOrderCellOtherActionView.h
//  Meidebi
//  已完成订单删除按钮弹窗
//  Created by mdb-losaic on 2020/2/11.
//  Copyright © 2020 penggj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderCellOtherActionViewDelegate <NSObject>

-(void)orderCellOtherActionItem:(id)model;

@end

@interface MyOrderCellOtherActionView : UIView

@property (nonatomic, weak)id<MyOrderCellOtherActionViewDelegate>delegate;

@property (nonatomic, retain) id model;


@end

NS_ASSUME_NONNULL_END
