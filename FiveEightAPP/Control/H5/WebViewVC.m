//
//  WebViewVC.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/1.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>

#import "WebViewDataControl.h"

@interface WebViewVC ()<WKNavigationDelegate>
{
    UIProgressView *progressView;
    WKWebView *webView;
    NSURL *url;
}
@end

@implementation WebViewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setNavigationBarTitle:nil leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
//    [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
}

- (instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)urlString {
    
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self setNavigationBarTitle:title leftImage:nil andRightImage:nil];
//        [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
        self.navigationItem.hidesBackButton = YES;
        
        //webView
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
//        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-0)];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        
        if (@available(iOS 11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        

        UINavigationBar *nav = self.navigationController.navigationBar;

        //progressView
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44-1, DEVICE_Width, 1)];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.tintColor = DEFAULTCOLOR2;
        progressView.trackTintColor = [UIColor whiteColor];
//         [self.view addSubview:progressView];
        
        
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        if (urlString) {
            url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];;
            [webView loadRequest:request];
        } else {
            [webView loadHTMLString:@"" baseURL:nil];
        }
        
        
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andLoadUrl:(NSString *)urlString
{
    
    self = [super init];
        if (self) {
            
            self.view.backgroundColor = [UIColor whiteColor];
            
            [self setNavigationBarTitle:title leftImage:nil andRightImage:nil];
    //        [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
            self.navigationItem.hidesBackButton = YES;
            
            //webView
            webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    //        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-0)];
            webView.navigationDelegate = self;
            [self.view addSubview:webView];
            
            if (@available(iOS 11.0, *)) {
                webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
                
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            

            UINavigationBar *nav = self.navigationController.navigationBar;

            //progressView
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44-1, DEVICE_Width, 1)];
            progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            progressView.tintColor = DEFAULTCOLOR2;
            progressView.trackTintColor = [UIColor whiteColor];
    //         [self.view addSubview:progressView];
            
            
            [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
            
            ////网络请求
            
            WebViewDataControl *datacontrl = [WebViewDataControl new];
            [datacontrl loadUrlData:[NSDictionary new] andurl:urlString andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
                if(state)
                {
                    [webView loadHTMLString:[NSString nullToString:[datacontrl.dicdata objectForKey:@"content"]] baseURL:nil];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:desc];
                }
            }];
            
        }
        return self;
}

- (void)leftBtnOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:progressView];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
//    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:YES];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [progressView removeFromSuperview];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
}

- (void)dealloc {
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == webView) {
            [progressView setAlpha:1.0f];
            [progressView setProgress:webView.estimatedProgress animated:YES];
            
            if(webView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [progressView setProgress:0.0f animated:NO];
                }];
                
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}


// 处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
