//
//  MSSheetView.m
//  MeiShi
//
//  Created by caochun on 16/4/19.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSSheetView.h"

#import "Masonry.h"
#import "UIView+Size.h"

@interface MSSheetView ()
{
    UIView *bgView;
    float bgViewHeight;
    
    UILabel *titleLabel;
    UIButton *ensureBtn;
}
@end

@implementation MSSheetView

+ (instancetype)sharedView {
    
    static dispatch_once_t once;
    static MSSheetView *sheetView;
    dispatch_once(&once, ^ {
        sheetView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];

        [sheetView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        
    });
    
    [sheetView removeAllView];
    [sheetView initView];
    
    return sheetView;
    
}

- (void)removeAllView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}


- (void)initView
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(DEVICE_Height);
//        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 49+50+5.5));
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 49));
    }];
    
//    bgViewHeight = 49+50+5.5;
    bgViewHeight = 49;
    
    //标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(153, 153, 153);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"标题";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 49));
    }];
    
//    //确定按钮
//    ensureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [ensureBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
//    [ensureBtn setBackgroundColor:[UIColor whiteColor]];
//    [ensureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [ensureBtn addTarget:self action:@selector(ensureBtnOnTouck:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:ensureBtn];
//    
//    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bgView).with.offset(0);
//        make.bottom.equalTo(bgView).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 50));
//    }];
    
    
}


- (void)ensureBtnOnTouck:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
        
        __block MSSheetView *weakSelf = self;
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf removeFromSuperview];
        });

    } completion:^(BOOL finished){
        
    }];
}


- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
        
        __block MSSheetView *weakSelf = self;
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf removeFromSuperview];
        });

    } completion:^(BOOL finished){
        
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        bgView.layer.transform = CATransform3DMakeTranslation(0, -bgViewHeight, 0);

    } completion:^(BOOL finished){
        
        
        
    }];
    
}

- (void)addSheetAction:(MSSheetAction*)sheetAction
{
    if (!sheetAction) {
        return;
    }
    
    NSLog(@"bgViewHeight:%f",bgViewHeight);
    
//    [sheetAction setOrigin:CGPointMake(0, bgViewHeight - 50 - 5.5)];
    [sheetAction setOrigin:CGPointMake(0, bgViewHeight)];
    [bgView addSubview:sheetAction];
    
    NSLog(@"yy:%f",sheetAction.frame.origin.y);
    
    bgViewHeight += sheetAction.frame.size.height;
    
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, bgViewHeight));
        
    }];

}


- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
    
    if (!title) {
        bgViewHeight -= 49;
        [titleLabel removeFromSuperview];
    }
}


- (void)setEnsureBtnTitle:(NSString*)title
{
    [ensureBtn setTitle:title forState:UIControlStateNormal];
}

@end
