//
//  ShareWebViewVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/7/30.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "ShareWebViewVC.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "YDShareView.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ThirdPlatformShare.h"

@interface ShareWebViewVC ()
{
    UIWebView *webView;
    NSURL *url;
    
    BOOL isFirstLoad;
}
@property(nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation ShareWebViewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
    
     self.navigationItem.hidesBackButton = YES;
}

- (instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)urlString {
    
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
        
        //webView
        
        webView = [[UIWebView alloc] init];
//        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.bottom.equalTo(self.view).with.offset(0);
        }];
        
        if (@available(iOS 11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //设置进度条代理
//        _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
//        webView.delegate = _progressProxy;
//        _progressProxy.webViewProxyDelegate = self;
//        _progressProxy.progressDelegate = self;
//
//        //创建进度条控件
//        CGFloat progressBarHeight = 2.f;
//        CGRect barFrame = CGRectMake(0, 0, DEVICE_Width, progressBarHeight);
//        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//        _progressView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
//        [webView addSubview:_progressView];
//
//        _progressProxy.progressBlock = ^(float progress) {
//            [_progressView setProgress:progress animated:NO];
//        };

        
        url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //清除webView的缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        //清除请求
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        //清除cookies
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        
        [webView loadRequest:request];
        
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
        [_bridge setWebViewDelegate:self];
        
        [self registerMethod];
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"exampleApp" ofType:@"html"];
//        NSURL* url = [NSURL  fileURLWithPath:path];//创建URL
//        request = [NSURLRequest requestWithURL:url];
//        [webView loadRequest:request];
        
    }
    return self;
}

- (void)leftBtnOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
     [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.view bringSubviewToFront:webView];
    

}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}


#pragma mark -
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)registerMethod {
    
    //JS调用原生
    [self.bridge registerHandler:@"leftBtnOnTouch"handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (responseCallback) {
            // 反馈给JS
        }
        [self leftBtnOnTouch:nil];
    }];
    
    [self.bridge registerHandler:@"saveImage"handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self dataURL2Image:data];
        
        if (responseCallback) {
            // 反馈给JS
            //            responseCallback(@{@"userId": @"123456"});
        }
    }];
    
    
    
    [self.bridge registerHandler:@"ShareToWx"handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self ShareToWx:data];
        
        if (responseCallback) {
            // 反馈给JS
//            responseCallback(@{@"userId": @"123456"});
        }
    }];
    
    //原生调用JS
    [self.bridge callHandler:@"setNavHeight"data:@{@"navHeight": [NSNumber numberWithInt:SafeAreaTopHeight]}responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
    
    
}


- (void)ShareToWx:(id)data {
    
    
    if (![ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        [SVProgressHUD showImage:nil status:@"未安装微信"];
        return;
    }
    
    SSDKPlatformType type;

    NSDictionary *dic = data;
    
    if ([[dic objectForKey:@"number"] intValue] == 1) {
        type = SSDKPlatformSubTypeWechatSession;
    } else {
        type = SSDKPlatformSubTypeWechatTimeline;
    }
    
    [ThirdPlatformShare shareToThirdPlatform:type
                                  withUrlStr:[dic objectForKey:@"link"]
                                   withTitle:[dic objectForKey:@"title"]
                                 withContent:[dic objectForKey:@"desc"]
                                   WithImage:[UIImage imageNamed:@"me_set_about_logo"]];

    
//    NSString *title = @"我正在使用Fitnew跑步，潮好玩的在线运动平台！";
//    NSString *content = @"创建3D运动形象，体验虚拟运动场景，实时在线跑友互动，精准数据采集量化！不要太好玩哦(☆＿☆)";
//
//    YDShareView *shareView = [YDShareView sharedView];
//    shareView.title = title;
//    shareView.image = [UIImage imageNamed:@"share_icon"];
//    shareView.url = [NSURL URLWithString:@"http://www.Fitnew.com"];
//    shareView.content = content;
//    shareView.from = 3;
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:shareView];
//    [shareView show];
    
}

- (void)dataURL2Image:(id)dataDic
{
//    NSString *imgSrc = [dataDic objectForKey:@"img_url"];
    NSURL *url = [NSURL URLWithString: dataDic];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    if (!image) {
        [SVProgressHUD showErrorWithStatus:@"获取图片失败"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片到相册失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片到相册成功"];
    }
}

@end
