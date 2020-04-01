//
//  NoticeTypeCell.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "NoticeTypeCell.h"

@implementation NoticeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.noticeImageView.layer setMasksToBounds:YES];
    [self.noticeImageView.layer setCornerRadius:self.noticeImageView.width/2.0];
    self.typeNameLabel.textColor = COL1;
    self.contentLabel.textColor = COL2;
    self.dateLabel.textColor = COL2;
    
//    self.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, self.badgeViewContainerView.width, self.badgeViewContainerView.height) withString:nil];
//    [self.badgeViewContainerView addSubview:self.badgeView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
