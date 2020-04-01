//
//  ShareWebViewVC.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/7/30.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "BaseVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ShareWebViewVC : BaseVC<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong ,nonatomic) NJKWebViewProgress *progressProxy;//进度条代理
@property (strong ,nonatomic) NJKWebViewProgressView *progressView;//加载H5进度控件

- (instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)urlString;

@end
