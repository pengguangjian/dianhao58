//
//  UIButton+QHButtonCtg.m
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import "UIButton+MSButtonCtg.h"

@implementation UIButton (MSButtonCtg)

- (void)setTitle:(NSString *)aTitle andFont:(UIFont *)aFont andTitleColor:(UIColor *)textColor andBgColor:(UIColor *)bgColor andRadius:(float)radius {
    [self setTitle:aTitle forState:UIControlStateNormal];
    self.titleLabel.font = aFont;
    [self setTitleColor:textColor forState:UIControlStateNormal];
    if (bgColor) {
        self.backgroundColor = bgColor;
    }
    
    if (radius>0) {
        self.layer.cornerRadius = radius;
    }
}

@end
