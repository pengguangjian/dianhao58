//
//  AvailableBalanceCell.m
//  TechnicianAPP
//
//  Created by Mac on 2018/7/17.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "AvailableBalanceCell.h"

@implementation AvailableBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.outMoneyBtn.layer setMasksToBounds:YES];
    [self.outMoneyBtn.layer setCornerRadius:5.0f];
    [self.outMoneyBtn.layer setBorderWidth:1.0];
    [self.outMoneyBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
