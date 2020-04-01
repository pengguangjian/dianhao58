//
//  PlayMSViewController.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/1.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface WebViewVC : BaseVC<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong ,nonatomic) NJKWebViewProgress *progressProxy;//进度条代理
@property (strong ,nonatomic) NJKWebViewProgressView *progressView;//加载H5进度控件

- (instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)urlString;

@end
