//
//  WalletListCell.h
//  TechnicianAPP
//
//  Created by Mac on 2018/7/17.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *cMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
