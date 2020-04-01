//
//  OrderNoticeDetailCell.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNoticeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
