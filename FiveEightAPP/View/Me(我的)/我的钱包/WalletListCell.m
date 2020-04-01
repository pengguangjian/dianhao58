//
//  WalletListCell.m
//  TechnicianAPP
//
//  Created by Mac on 2018/7/17.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "WalletListCell.h"

@implementation WalletListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.textColor = COL1;
    _dateTimeLabel.textColor = COL2;
    
    _moneyLabel.textColor = COL1;
    _cMoneyLabel.textColor = COL1;
    _statusLabel.textColor = REDCOLOR;
    
    [_typeLabel.layer setMasksToBounds:YES];
    [_typeLabel.layer setCornerRadius:_typeLabel.width/2.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
