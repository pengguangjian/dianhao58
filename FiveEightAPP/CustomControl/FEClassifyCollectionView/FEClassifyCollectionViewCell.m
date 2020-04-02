//
//  FEClassifyCollectionViewCell.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "FEClassifyCollectionViewCell.h"

@implementation FEClassifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.classifyLabel.textColor = COL1;
    [self.classifyLabel.layer setMasksToBounds:YES];
    [self.classifyLabel.layer setCornerRadius:3];
    [self.classifyLabel.layer setBorderColor:RGB(200, 200, 200).CGColor];
    [self.classifyLabel.layer setBorderWidth:1];
    self.classifyLabel.height = 35;
    self.classifyLabel.adjustsFontSizeToFitWidth = YES;
    self.classifyLabel.minimumScaleFactor = 8;
    
    [self.redView.layer setMasksToBounds:YES];
    [self.redView.layer setCornerRadius:self.redView.width/2.f];
}

@end
