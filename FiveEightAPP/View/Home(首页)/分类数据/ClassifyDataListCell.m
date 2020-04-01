//
//  ClassifyDataListCell.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/16.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "ClassifyDataListCell.h"

@implementation ClassifyDataListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = COL1;
    self.timeLabel.textColor = COL3;
    self.commentNumLabel.textColor = COL3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
