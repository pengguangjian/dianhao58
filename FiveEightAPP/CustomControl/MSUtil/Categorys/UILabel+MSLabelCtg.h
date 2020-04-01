//
//  UILabel+QHLabelCtg.h
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSHead.h"

#define minPriceShowNoPrice 10

@interface UILabel (MSLabelCtg)

- (void)setText:(NSString *)aText andFont:(UIFont *)aFont andTextColor:(UIColor *)aColor;

//price单位是 分
- (void)setAsAttributedPriceLableWithPriceStr:(int)price ;

+ (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing andString:(NSString *)string;



@end
