//
//  MDBEmptyView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MDBEmptyView.h"

static NSString * const kRemindTextColor = @"#666666";
static CGFloat const kRemindTextFontSize = 14.f;
@interface MDBEmptyView ()

@property (nonatomic, strong) UILabel *remindTextLabel;

@end

@implementation MDBEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-50);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"not_data"];
    
    _remindTextLabel = [UILabel new];
    [self addSubview:_remindTextLabel];
    [_remindTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    _remindTextLabel.numberOfLines = 0;
    _remindTextLabel.textAlignment = NSTextAlignmentCenter;
    _remindTextLabel.textColor = RGB(180, 180, 180);
    _remindTextLabel.font = [UIFont systemFontOfSize:kRemindTextFontSize];
}

#pragma mark - setters and getters
- (void)setRemindStr:(NSString *)remindStr{
    _remindStr = remindStr;
    _remindTextLabel.text = remindStr;
}


@end
