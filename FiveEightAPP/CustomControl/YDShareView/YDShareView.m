//
//  YDShareView.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/24.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "YDShareView.h"

#import "UIView+Size.h"
#import "Masonry.h"
#import "UIView+Masonry_LJC.h"
#import "ThirdPlatformShare.h"

#import "MTA.h"
#import "MTAConfig.h"


#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "SVProgressHUD.h"

@interface YDShareView ()
{
    UIView *bgView;
    
    NSInteger btnTag;
    
    UIImageView *cutImageView;
}
@end

@implementation YDShareView

+ (instancetype)sharedView {
    
    static dispatch_once_t once;
    static YDShareView *shareView;
    dispatch_once(&once, ^ {
        shareView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        
        [shareView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        
        [shareView initView];
        
    });
    
//    shareView.layer.transform = CATransform3DMakeTranslation(0, DEVICE_Height, 0);
    
    return shareView;
    
}

- (void)initView
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//    [self addGestureRecognizer:tapGesture];
    
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 200));//-62-13
    }];
    bgView.layer.transform = CATransform3DMakeTranslation(0, DEVICE_Height, 0);
    
//    cutImageView = [[UIImageView alloc] init];
//    cutImageView.image = _image;
//    [self addSubview:cutImageView];
//    [cutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self).with.offset(-240);
//        make.size.mas_equalTo(CGSizeMake((DEVICE_Height-200-80)*(DEVICE_Width/DEVICE_Height), DEVICE_Height-200-80));
//    }];
//    cutImageView.layer.transform = CATransform3DMakeTranslation(0, -DEVICE_Height, 0);
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COL2;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"分享到";
    [bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(18);
        make.left.equalTo(bgView).with.offset(18);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-18*2, 16));
    }];
    

    UIView *containerView = [[UIView alloc] init];
    [containerView setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(17);
        make.left.equalTo(bgView).with.offset(28);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-28*2, 63));
    }];
    
    NSMutableArray *containerViewSubViews = [[NSMutableArray alloc] init];
    
    UIView *bottomContainerView = nil;
    NSMutableArray *bottomContainerViewSubViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<2; i++) {
        
        UIView *pView = nil;
        NSString *imageName = nil;
        NSString *title = nil;
        
        switch (i) {
//            case 0:
//                imageName = @"share_ic_fitnew";
//                title = @"Fitnew";
//                break;
            case 0:
                imageName = @"share_ic_weixin";
                title = @"微信";
                break;
            case 1:
                imageName = @"share_ic_pengyouquan";
                title = @"朋友圈";
                break;
            case 2:
                imageName = @"share_ic_weibo";
                title = @"微博";
                break;
            case 3:
                imageName = @"share_ic_qq";
                title = @"QQ";
                break;
            case 4:
                imageName = @"share_ic_kongjian";
                title = @"QQ空间";
                break;
//            case 6:
//                imageName = @"share_ic_download";
//                title = @"保存到手机";
//                break;
            default:
                break;
        }
        
        if (!bottomContainerView) {
            pView = containerView;
        } else {
            pView = bottomContainerView;
        }
        
        if (title) {
            UIButton * shareBtn = [self createBtnWithParentView:pView withBtnImageName:imageName withBtnTitle:title];
            
            shareBtn.tag = i;
            
            if (containerViewSubViews.count < 4) {
                [containerViewSubViews addObject:shareBtn];
            } else {
                [bottomContainerViewSubViews addObject:shareBtn];
            }
        }
        
        if ((containerViewSubViews.count >= 4) && !bottomContainerView) {
            bottomContainerView = [[UIView alloc] init];
            [bottomContainerView setBackgroundColor:[UIColor clearColor]];
            [bgView addSubview:bottomContainerView];
            [bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(containerView.mas_bottom).with.offset(13);
                make.left.equalTo(bgView).with.offset(28);
                make.size.mas_equalTo(CGSizeMake(DEVICE_Width-28*2, 63));
            }];
        }
        
    }
    
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        float width = (DEVICE_Width-56)/2.0*containerViewSubViews.count;
        make.size.mas_equalTo(CGSizeMake(width, 63));
        
    }];
    
    [bottomContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        float width = (DEVICE_Width-56)/2.0*bottomContainerViewSubViews.count;
        make.size.mas_equalTo(CGSizeMake(width, 63));
        
    }];
    
   
    
    
    [containerView distributeSpacingHorizontallyWith:containerViewSubViews];
    
    if (bottomContainerViewSubViews.count>0) {
        [bottomContainerView distributeSpacingHorizontallyWith:bottomContainerViewSubViews];
    }
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SEPARATORCOLOR;
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).with.offset(-50);
        make.left.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 1));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:COL3 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn.layer setMasksToBounds:YES];
    //    [cancelBtn.layer setCornerRadius:5.0];
    cancelBtn.xsz_acceptEventInterval = 1;
    //    [cancelBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).with.offset(-0);
        make.left.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 50));
    }];
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    cutImageView.image = _image;
}

- (void)cancelBtnOnTouch:(id)sender {
    [self tapGestureAction:nil];
}


- (UIButton *)createBtnWithParentView:(UIView*)parentView
                     withBtnImageName:(NSString*)imageName
                         withBtnTitle:(NSString*)title{
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    UIImage *shareImage = [UIImage imageNamed:imageName];
    //UIImageRenderingModeAlwaysOriginal这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
    shareImage = [shareImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //setImage 是会渲染的
    [shareBtn setImage:shareImage forState:UIControlStateNormal];
    [shareBtn setTitleColor:COL2 forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [shareBtn addTarget:self action:@selector(shareBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:shareBtn];

    //UILabel固定宽度，根据内容计算字号
    CGSize maxSize = CGSizeMake(DEVICE_Width, MAXFLOAT);
    float btnWidth = (DEVICE_Width-56)/4.0;
    
    CGSize titlesize = [title sizeWithFont:[UIFont systemFontOfSize:1]
                                                 constrainedToSize:maxSize
                                                     lineBreakMode:NSLineBreakByWordWrapping];
    int titleFontSize = (int)btnWidth/titlesize.width;
    
    if (titleFontSize < 14) {
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:titleFontSize]];
    }
    
    
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(- (63 - 40), ((DEVICE_Width-56)/4.0-40)/2.0, 0.0, ((DEVICE_Width-56)/4.0-40)/2.0);
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, - (63 - 16), 0);
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake((DEVICE_Width-56)/4.0, 63));
    }];
    
    return shareBtn;
    
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    
    if (self.hiddenHandler) {
        self.hiddenHandler();
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        bgView.layer.transform = CATransform3DMakeTranslation(0, DEVICE_Height, 0);
        cutImageView.layer.transform = CATransform3DMakeTranslation(0, DEVICE_Height, 0);
        
    } completion:^(BOOL finished){
        cutImageView.layer.transform = CATransform3DMakeTranslation(0, -DEVICE_Height, 0);
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        bgView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.5 animations:^{
             cutImageView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            
        } completion:^(BOOL finished){
           
        }];
        
       
    }];
    
}

- (void)shareBtnOnTouch:(UIButton*)btn
{
//    if (_from == 1) {
//        [MobClick event:@"click_yd_screenshotsharesuccess"];
//    }
//    if (_from == 2) {
//        [MobClick event:@"click_yd_trailsharesuccess"];
//    }
//    if (_from == 3) {
//        [MobClick event:@"click_yd_fitnewsharesuccess"];
//    }
    
    btnTag = btn.tag;
    
    [self shareToPlatform];
    
    
}


- (void)shareToPlatform {
    
    switch (btnTag) {
//        case 0:
//            //            title = @"Fitnew";
//            break;
        case 0:
            
            if (![ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
                [SVProgressHUD showImage:nil status:@"未安装微信"];
                return;
            }
            
            [ThirdPlatformShare shareToThirdPlatform:SSDKPlatformSubTypeWechatSession
                                          withUrlStr:_url
                                           withTitle:_title
                                         withContent:_content
                                           WithImage:_image];
            
            break;
        case 1:
            if (![ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
                [SVProgressHUD showImage:nil status:@"未安装微信"];
                return;
            }
            [ThirdPlatformShare shareToThirdPlatform:SSDKPlatformSubTypeWechatTimeline
                                          withUrlStr:_url
                                           withTitle:_title
                                         withContent:_content
                                           WithImage:_image];
            break;
        case 2:
            
        {
            NSString *title = nil;
            UIImage *image = nil;
            
            
            
            NSString *text = nil;
            if (title) {
                text = title;
            }
            if (_url) {
                text = [text stringByAppendingString:_url.absoluteString];
            }
            
            
            [ThirdPlatformShare shareToThirdPlatform:SSDKPlatformTypeSinaWeibo
                                          withUrlStr:_url
                                           withTitle:text
                                         withContent:text
                                           WithImage:image];
            
            break;
        }
            
            
        case 3:
            if (![ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
                [SVProgressHUD showImage:nil status:@"未安装QQ"];
                return;
            }
            [ThirdPlatformShare shareToThirdPlatform:SSDKPlatformSubTypeQQFriend
                                          withUrlStr:_url
                                           withTitle:_title
                                         withContent:_content
                                           WithImage:_image];
            break;
        case 4:
            if (![ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
                [SVProgressHUD showImage:nil status:@"未安装QQ"];
                return;
            }
            [ThirdPlatformShare shareToThirdPlatform:SSDKPlatformSubTypeQZone
                                          withUrlStr:_url
                                           withTitle:_title
                                         withContent:_content
                                           WithImage:_image];
            break;
//        case 6:
//            
//            //            title = @"保存到手机";
//            break;
        default:
            break;
    }
    
}


@end
