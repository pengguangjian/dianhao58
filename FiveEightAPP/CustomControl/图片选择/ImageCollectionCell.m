//
//  ImageCollectionCell.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self layoutIfNeeded];
}

- (void)setContentMode:(UIViewContentMode)mode {
    _imageView.contentMode = mode;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
