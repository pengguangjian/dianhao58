//
//  ImageCollectionCell.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//


// 图片Cell
#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

- (void)setImage:(UIImage *)image;

- (UIImage *)image;

- (void)setContentMode:(UIViewContentMode)mode;

@end
