//
//  RemoteImageCell.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "RemoteImageCell.h"


@interface RemoteImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RemoteImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.contentView.bounds;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_imageView sd_setImageWithURL:_imageURL placeholderImage:nil];
}

@end
