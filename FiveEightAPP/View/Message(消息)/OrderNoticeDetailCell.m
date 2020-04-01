//
//  OrderNoticeDetailCell.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "OrderNoticeDetailCell.h"

@implementation OrderNoticeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeNameLabel.textColor = COL1;
    self.contentLabel.textColor = COL2;
    self.dateLabel.textColor = COL2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
