//
//  AboutVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/14.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "AboutVC.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"systemAbout", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: COL1,
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    
}

-(void)leftBtnOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView {
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    scrollView.contentSize = (CGSize){DEVICE_Width,scrollView.height};
//    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:bgView];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"me_set_about_bg"];
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.right.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(0);
        make.bottom.equalTo(bgView).with.offset(0);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"me_set_about_logo"];
    [bgView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(50);
        make.centerX.mas_equalTo(bgView);
        make.width.mas_equalTo(@(230/2.0));
        make.height.mas_equalTo(@(240/2.0));

    }];
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //版本号
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = COL2;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"ALOVN %@", app_Version];
    [bgView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.equalTo(logoImageView.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 16));
    }];
    
    
    UIButton *userAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userAgreementBtn addTarget:self action:@selector(userAgreementBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    userAgreementBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [userAgreementBtn setTitleColor:DEFAULTCOLOR2 forState:UIControlStateNormal];
    [userAgreementBtn setTitle:NSLocalizedString(@"shiyongxieyijishengm", nil) forState:UIControlStateNormal];
    [userAgreementBtn setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:userAgreementBtn];
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).with.offset(-50);
        make.centerX.mas_equalTo(bgView);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@50);

    }];
    
    scrollView.contentSize = (CGSize){DEVICE_Width,scrollView.height+1};

}

//协议及声明
- (void)userAgreementBtnOnTouch:(id)sender {
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/uallAgreement.html?type=2", H5ADDR];
//    WebViewVC *vc = [[WebViewVC alloc] initWithTitle:@"使用协议及声明" andUrl:urlStr];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
