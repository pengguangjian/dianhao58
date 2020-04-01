//
//  FindListCell.m
//  FiveEightAPP
//
//  Created by Cc on 2019/12/9.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "FindListCell.h"

@implementation FindListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgview.layer setMasksToBounds:YES];
    [self.bgview.layer setCornerRadius:5.0];
    
    [self.bgImageView.layer setMasksToBounds:YES];
    [self.bgImageView.layer setCornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
