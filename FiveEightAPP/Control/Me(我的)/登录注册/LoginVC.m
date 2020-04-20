//
//  LoginVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "LoginVC.h"

#import "YDScrollView.h"
#import "ThirdPlatformLogin.h"
#import "DHGuidePageHUD.h"
#import "LoginForgetPwdVC.h"

#import "LoginUser.h"
#import "ResignVC.h"
#import "LoginDataControl.h"
#import "SmsProtoctFunction.h"
#import "BindingVC.h"

#import <ZaloSDK/ZaloSDK.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface LoginVC ()<MSNavSliderMenuDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
{
    
    UIScrollView *scvback;
    
    MSNavSliderMenu *navSliderMenu;
    NSMutableDictionary  *listVCQueue;
    TPKeyboardAvoidingScrollView *contentScrollView;
    int menuCount;
    
    SSDKUser *ssdkUser;
    UIButton *requestVerityCodeBtn;
    
    NSMutableArray *languageArr;
    
    LoginDataControl *datacontrol;
    ///第三方昵称
    NSString *strotherNickName;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mPageName = @"登录";
    strotherNickName = @"";
    [self initView];
    
    [self setNavigationBarTitle:@"" leftImage:nil andRightImage:[UIImage imageNamed:@"nav_close_gray"]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
//        [self setStaticGuidePage];
        
        // 动态引导页
//         [self setDynamicGuidePage];
        
        // 视频引导页
//         [self setVideoGuidePage];
    }
    
    
//    locationTracker = [LocationTracker sharedLocationManager];
//    [locationTracker startLocationTracking];
    
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeFacebook result:^(NSError *error) {
        NSLog(@"");
    }];
        
    [[ZaloSDK sharedInstance] unauthenticate];
    
    datacontrol = [LoginDataControl new];
    
}

- (void)rightBtnOnTouch:(id)sender {
    
    [Util changeRootVC];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:NO];
    
 //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setNavigationBarTitle:@"" leftImage:nil andRightImage:[UIImage imageNamed:@"nav_close_gray"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:YES];
    
 //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    scvback = [[UIScrollView alloc] init];

    [self.view addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(DEVICE_Width);
        make.top.offset(0);
        make.height.offset(DEVICE_Height);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"log_log"];
    [scvback addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SafeAreaTopHeight+10);
        make.centerX.equalTo(self->scvback);
        make.size.mas_equalTo(CGSizeMake(140/2.0, 140/2.0));
    }];
    
    
    _menuType = MSNavSliderMenuTypeTitleOnly;
    [self initMSNavSliderMenu];
    
    [self thirdpartyLoginView];
}

- (void)initMSNavSliderMenu {
    
    menuCount = 2;
    
    ///第一个子视图为scrollView或者其子类的时候 会自动设置 inset为64 这样navSliderMenu会被下移 所以最好设置automaticallyAdjustsScrollViewInsets为no 或者[self.view addSubview:[UIView new]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MSNavSliderMenuStyleModel *model = [MSNavSliderMenuStyleModel new];
    
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"quickLogin", nil), NSLocalizedString(@"passwordLogin", nil), nil];
    
    model.menuTitles = [titles copy];
    
    model.lineHeight = 2;
    model.titleLableFont = [UIFont systemFontOfSize:16];
    model.menuWidth = ((double)DEVICE_Width) / menuCount;
    model.menuHorizontalSpacing = 0.0f;
    model.sliderMenuTextColorForSelect = RGB(234, 58, 60);
    model.autoSuitLineViewWithdForBtnTitle = YES;
    
    navSliderMenu = [[MSNavSliderMenu alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight*SCREENPROPERTION+122/2.0+35*SCREENPROPERTION, DEVICE_Width, 45) andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *navSliderMenuMaskPath = [UIBezierPath bezierPathWithRoundedRect:navSliderMenu.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *navSliderMenuMaskLayer = [[CAShapeLayer alloc] init];
    navSliderMenuMaskLayer.frame = navSliderMenu.bounds;
    navSliderMenuMaskLayer.path = navSliderMenuMaskPath.CGPath;
    navSliderMenu.layer.mask = navSliderMenuMaskLayer;
    
    [scvback addSubview:navSliderMenu];
    
    // 用于滑动的滚动视图
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight*SCREENPROPERTION+122/2.0+35*SCREENPROPERTION+45, navSliderMenu.width, 250)];
    contentScrollView.contentSize = (CGSize){navSliderMenu.width*menuCount,contentScrollView.frame.size.height};
//    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    //    contentScrollView.scrollsToTop  = NO;
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    [scvback addSubview:contentScrollView];
    
    [self addListVCWithIndex:0];
    [self addListVCWithIndex:1];
    
    contentScrollView.scrollEnabled = NO;
}

#pragma mark - MSNavSliderMenuDelegate

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+navSliderMenu.width/2.f)/navSliderMenu.width) andDelegate:YES];
    
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/navSliderMenu.width)+1];
    
}

#pragma mark - MSNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    
    //让scrollview滚到相应的位置
    [contentScrollView setContentOffset:CGPointMake(row*navSliderMenu.width, contentScrollView.contentOffset.y)  animated:NO];
    
    //根据页数添加相应的视图
    [self addListVCWithIndex:row];
}

#pragma mark -addVC

- (void)addListVCWithIndex:(NSInteger)index {
    if (!listVCQueue) {
        listVCQueue = [[NSMutableDictionary alloc] init];
    }
    if (index<0 || index>=menuCount) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    if (![listVCQueue objectForKey:@(index)]) {
        
        if (index == 0) {
            [self shortcutLoginView];
        } else if (index == 1) {
            [self pwdLoginView];
        }
    }
}

#pragma mark - 验证码登录
- (void)shortcutLoginView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.width, contentScrollView.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView addSubview:bgView];
    [listVCQueue setObject:bgView forKey:@(0)];
    
    UIBezierPath *bgViewMaskPath = [UIBezierPath bezierPathWithRoundedRect:contentScrollView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *bgViewMaskLayer = [[CAShapeLayer alloc] init];
    bgViewMaskLayer.frame = contentScrollView.bounds;
    bgViewMaskLayer.path = bgViewMaskPath.CGPath;
    bgView.layer.mask = bgViewMaskLayer;
    
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.placeholder = NSLocalizedString(@"pleaseMobile", nil);
    phoneTextField.tag = 100;
//    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [phoneTextField addTarget:self action:@selector(phoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.equalTo(bgView).with.offset(20);
        make.right.equalTo(bgView).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    //    [phoneTextField becomeFirstResponder];
    
    UIView *phoneTextFieldBelowLine = [[UIView alloc]init];
    phoneTextFieldBelowLine.backgroundColor = SEPARATORCOLOR;
    [bgView addSubview:phoneTextFieldBelowLine];
    [phoneTextFieldBelowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(phoneTextField.mas_bottom).with.offset(5);
        make.left.equalTo(phoneTextField.mas_left);
        make.right.equalTo(phoneTextField.mas_right);
        
        make.height.mas_equalTo(@0.5);
    }];
    
    
    requestVerityCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestVerityCodeBtn addTarget:self action:@selector(requestVerityCodeBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    requestVerityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    requestVerityCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [requestVerityCodeBtn setTitle:NSLocalizedString(@"getCode", nil) forState:UIControlStateNormal];
    [requestVerityCodeBtn setBackgroundColor:RGB(234, 58, 60)];
    [requestVerityCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestVerityCodeBtn.layer setCornerRadius:3];
    [requestVerityCodeBtn.layer setMasksToBounds:YES];
    [bgView addSubview:requestVerityCodeBtn];
    [requestVerityCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).with.offset(-25);
        make.top.equalTo(phoneTextFieldBelowLine.mas_bottom).with.offset(20);
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(@120);
    }];
    
    
    
    UITextField *verityCodeTextField = [[UITextField alloc]init];
    verityCodeTextField.font = [UIFont systemFontOfSize:15];
    verityCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verityCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    verityCodeTextField.placeholder = NSLocalizedString(@"pleaseCode", nil);
    verityCodeTextField.tag = 101;
    verityCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [verityCodeTextField addTarget:self action:@selector(verityCodeTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:verityCodeTextField];
    [verityCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->requestVerityCodeBtn);
        make.left.equalTo(phoneTextField);
        make.right.equalTo(self->requestVerityCodeBtn.mas_left).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    UIView *pwdTextFieldBelowLine = [[UIView alloc]init];
    pwdTextFieldBelowLine.backgroundColor = SEPARATORCOLOR;
    [bgView addSubview:pwdTextFieldBelowLine];
    [pwdTextFieldBelowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(verityCodeTextField.mas_bottom).with.offset(5);
        make.left.equalTo(verityCodeTextField.mas_left);
        make.right.equalTo(phoneTextFieldBelowLine.mas_right);
        
        make.height.mas_equalTo(@0.5);
    }];
    
    
    UIButton *shortcutLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shortcutLoginBtn addTarget:self action:@selector(shortcutLoginBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    shortcutLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [shortcutLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shortcutLoginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [shortcutLoginBtn setBackgroundColor:RGB(234, 58, 60)];
    [shortcutLoginBtn.layer setMasksToBounds:YES];
    [shortcutLoginBtn.layer setCornerRadius:5.0f];
//    shortcutLoginBtn.xsz_acceptEventInterval = 1;
//    [shortcutLoginBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [bgView addSubview:shortcutLoginBtn];
    [shortcutLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).with.offset(-10);
        make.left.offset(30);
        make.right.equalTo(bgView).offset(-30);
        make.height.mas_equalTo(@50);
    }];
    
    
    
}
#pragma mark - 密码登录
- (void)pwdLoginView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(contentScrollView.width, 0, contentScrollView.width, contentScrollView.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView addSubview:bgView];
    [listVCQueue setObject:bgView forKey:@(1)];
    
    UIBezierPath *bgViewMaskPath = [UIBezierPath bezierPathWithRoundedRect:contentScrollView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *bgViewMaskLayer = [[CAShapeLayer alloc] init];
    bgViewMaskLayer.frame = contentScrollView.bounds;
    bgViewMaskLayer.path = bgViewMaskPath.CGPath;
    bgView.layer.mask = bgViewMaskLayer;
    
    
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.placeholder = NSLocalizedString(@"pleaseMobile", nil);
    phoneTextField.tag = 100;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(30);
        make.left.equalTo(bgView).with.offset(20);
        make.right.equalTo(bgView).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];

    
    UIView *phoneTextFieldBelowLine = [[UIView alloc]init];
    phoneTextFieldBelowLine.backgroundColor = SEPARATORCOLOR;
    [bgView addSubview:phoneTextFieldBelowLine];
    [phoneTextFieldBelowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(phoneTextField.mas_bottom).with.offset(5);
        make.left.equalTo(phoneTextField.mas_left);
        make.right.equalTo(phoneTextField.mas_right);
        
        make.height.mas_equalTo(@0.5);
    }];
    
    UITextField *pwdTextField = [[UITextField alloc]init];
    pwdTextField.font = [UIFont systemFontOfSize:15];
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    pwdTextField.placeholder = NSLocalizedString(@"pleasePassWord", nil);
    pwdTextField.tag = 101;
    pwdTextField.secureTextEntry = YES;
    [bgView addSubview:pwdTextField];
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(30);
        make.left.right.height.equalTo(phoneTextField);
    }];
    
    UIView *pwdTextFieldBelowLine = [[UIView alloc]init];
    pwdTextFieldBelowLine.backgroundColor = SEPARATORCOLOR;
    [bgView addSubview:pwdTextFieldBelowLine];
    [pwdTextFieldBelowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(pwdTextField.mas_bottom).with.offset(5);
        make.left.equalTo(pwdTextField.mas_left);
        make.right.equalTo(phoneTextFieldBelowLine.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
    
    UIButton *pwdLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdLoginBtn addTarget:self action:@selector(pwdLoginBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    pwdLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [pwdLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pwdLoginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [pwdLoginBtn setBackgroundColor:RGB(234, 58, 60)];
    [pwdLoginBtn.layer setMasksToBounds:YES];
    [pwdLoginBtn.layer setCornerRadius:5.0f];
//    pwdLoginBtn.xsz_acceptEventInterval = 1;
//    [pwdLoginBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [bgView addSubview:pwdLoginBtn];
    [pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).with.offset(-10);
        make.left.offset(30);
        make.right.equalTo(bgView).offset(-30);
        make.height.mas_equalTo(@50);
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 第三方账号登录
- (void)thirdpartyLoginView {
    
    float p = SCREENPROPERTION;
    
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [forgetPwdBtn setTitleColor:RGB(130, 130, 130) forState:UIControlStateNormal];
    [forgetPwdBtn setTitle:[NSString stringWithFormat:@"%@？", NSLocalizedString(@"forgetPassword", nil)] forState:UIControlStateNormal];
    [scvback addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->contentScrollView.mas_bottom);
        make.right.offset(DEVICE_Width/2.0-20);
        make.height.mas_equalTo(@25);
    }];
    
    UIView *viewlines = [[UIView alloc] init];
    [viewlines setBackgroundColor:RGB(180, 180, 180)];
    [scvback addSubview:viewlines];
    [viewlines mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(forgetPwdBtn.mas_right).offset(20);
        make.top.equalTo(forgetPwdBtn).offset(5);
        make.size.sizeOffset(CGSizeMake(1, 10));
    }];
    
    UIButton *btresign = [[UIButton alloc] init];
    [btresign setTitle:NSLocalizedString(@"lijiregister", nil) forState:UIControlStateNormal];
    [btresign setTitleColor:RGB(130, 130, 130) forState:UIControlStateNormal];
    [btresign.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [scvback addSubview:btresign];
    [btresign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewlines).offset(20);
        make.top.height.equalTo(forgetPwdBtn);
    }];
    [btresign addTarget:self action:@selector(resignAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = RGB(50, 50, 50);
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.text = NSLocalizedString(@"thirdLogin", nil);
    descLabel.textAlignment = NSTextAlignmentCenter;
    [scvback addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->contentScrollView);
        make.top.equalTo(btresign.mas_bottom).offset(30);
        make.height.offset(16);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    [leftView setBackgroundColor:RGB(240, 240, 240)];
    [scvback addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(descLabel);
        make.right.equalTo(descLabel.mas_left).with.offset(-10);
        make.left.offset(30);
        make.height.offset(1);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [rightView setBackgroundColor:RGB(240, 240, 240)];
    [scvback addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(descLabel);
        make.left.equalTo(descLabel.mas_right).with.offset(10);
        make.right.equalTo(self->contentScrollView).offset(-30);
        make.height.offset(1);
    }];
    
    
    UIButton *btf = [[UIButton alloc] init];
    [btf setImage:[UIImage imageNamed:@"facebookLogin"] forState:UIControlStateNormal];
    [scvback addSubview:btf];
    [btf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(50, 50));
        make.top.equalTo(descLabel.mas_bottom).offset(15);
         make.left.offset(DEVICE_Width/2.0-60);
        
    }];
    [btf setTag:100];
    [btf addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btzhiliao = [[UIButton alloc] init];
    [btzhiliao setImage:[UIImage imageNamed:@"zaloLogin"] forState:UIControlStateNormal];
    [scvback addSubview:btzhiliao];
    [btzhiliao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(50, 50));
        make.top.equalTo(btf);
        make.left.equalTo(btf.mas_right).offset(20);
    }];
    [btzhiliao setTag:101];
    [btzhiliao addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 13.0, *))
    {
        
        [btf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(DEVICE_Width/2.0+20);
        }];
        
        ASAuthorizationAppleIDButton *loginBtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        [loginBtn addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
        [scvback addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(120, 40));
            make.top.equalTo(descLabel.mas_bottom).offset(15);
            make.right.equalTo(btf.mas_left).offset(-10);
//            make.top.equalTo(btf.mas_bottom).offset(10);
//            make.centerX.equalTo(descLabel);
        }];
        
    }
    
    
    
    //获取系统语言
//    NSArray *languages = [NSLocale preferredLanguages];
    
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    
    if (!([userSettingLanguage isEqualToString:@"zh-Hans"]||
        [userSettingLanguage isEqualToString:@"vi"])) {
        userSettingLanguage = @"zh-Hans";
    }
    
    NSArray *arrtitle = @[@"Tiếng Việt",@"中文"];//,@"English"
    NSArray *arrname = @[@"vi",@"zh-Hans"];
    languageArr  = [[NSMutableArray alloc] init];
    int i = 0;
    for(NSString *strtitle in arrtitle)
    {
        UIButton *chineseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chineseBtn setTitle:strtitle forState:UIControlStateNormal];
        [chineseBtn setTitleColor:ORANGEREDCOLOR forState:UIControlStateSelected];
        [chineseBtn setTitleColor:COL2 forState:UIControlStateNormal];
        [chineseBtn addTarget:self action:@selector(setAppLanguage:) forControlEvents:UIControlEventTouchUpInside];
        chineseBtn.tag = i;
        chineseBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [scvback addSubview:chineseBtn];
        if ([userSettingLanguage isEqualToString:arrname[i]]) {
            [chineseBtn setSelected:YES];
        }
        [languageArr addObject:chineseBtn];
        [chineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (@available(iOS 13.0, *))
            {
                make.top.equalTo(btf.mas_bottom).with.offset(70);
            }
            else
            {
                make.top.equalTo(btf.mas_bottom).with.offset(20);
            }
            
            make.size.mas_equalTo(CGSizeMake(70, 20));
            make.left.offset(DEVICE_Width/2.0-70+70*i);
            
        }];
        i++;
        
    }
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 13.0, *))
        {
            make.bottom.equalTo(btf.mas_bottom).with.offset(110);
        }
        else
        {
            make.bottom.equalTo(btf.mas_bottom).with.offset(60);
        }
        
    }];
    
}

- (void)toCountdown {
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"getCode", nil)];
                [self->requestVerityCodeBtn setTitle:title forState:UIControlStateNormal];
                self->requestVerityCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{

                NSString *title = [NSString stringWithFormat:@"%@s%@",strTime,NSLocalizedString(@"chongxinhuoqu", nil)];
                [self->requestVerityCodeBtn setTitle:title forState:UIControlStateNormal];
                self->requestVerityCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


# pragma mark - 点击事件

#pragma mark -///其他登录
-(void)otherLoginAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            {///fb
                [self facebookLoginBtnOnTouch];
//                [self thirdLogin:1 withBindCode:@"sdkff2384234"];
            }
            break;
         case 101:
            {//zalo
                [self zaloLoginBtnOnTouch];
            }
            break;
        default:
            break;
    }
    
}

-(void)signInWithApple
{
    [self didAppleAction];
}

#pragma mark - ///注册
-(void)resignAction
{
    ResignVC *rvc = [[ResignVC alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
    
}
#pragma mark - 获取验证码
- (void)requestVerityCodeBtnOnTouch:(UIButton*)btn {
    
    UIView *superView = btn.superview;
    UITextField *phoneTextField = (UITextField*)[superView viewWithTag:100];
    if (phoneTextField.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    [btn setUserInteractionEnabled:NO];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:phoneTextField.text forKey:@"mobile"];


    [SmsProtoctFunction smsRegionalData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [SVProgressHUD showSuccessWithStatus:desc];
            [self toCountdown];
        }
        else
        {
            [btn setUserInteractionEnabled:YES];
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
}
#pragma mark - +86
- (void)countryCodeBtnOnTouch:(UIButton *)sender {
    
}
#pragma mark///验证码登录
- (void)shortcutLoginBtnOnTouch:(UIButton*)btn {
    
//    [self pushSettingPwdVC];
    UIView *superView = btn.superview;
    UITextField *phoneTextField = (UITextField*)[superView viewWithTag:100];
    UITextField *pwdTextField = (UITextField*)[superView viewWithTag:101];
    
    if (phoneTextField.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    
    if (!(pwdTextField.text && pwdTextField.text.length>0)) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseCode", nil)];
        return;
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:phoneTextField.text forKey:@"mobile"];
    [dicpush setObject:pwdTextField.text forKey:@"smscode"];
    
    [datacontrol loginPhonePushData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:[self->datacontrol.dicLogin objectForKey:@"userinfo"]];
            [loginUser saveUser];
            //成功登录
            [Util changeRootVC];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
}
#pragma mark - 密码登录
- (void)pwdLoginBtnOnTouch:(UIButton*)btn {
    
//    BOOL networkStatus =  [NetWorkManager instance].status;
//    if (!networkStatus) {
//        [SVProgressHUD showErrorWithStatus:@"网络不可用，请检查网络"];
//    }

    UIView *superView = btn.superview;
    UITextField *phoneTextField = (UITextField*)[superView viewWithTag:100];
    UITextField *pwdTextField = (UITextField*)[superView viewWithTag:101];

//    BOOL isEffective = [Util validateMobile:phoneTextField.text];
    if (phoneTextField.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }

    if (!(pwdTextField.text && pwdTextField.text.length>0)) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleasePassWord", nil)];
        return;
    }

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if (phoneTextField.text && phoneTextField.text.length>0) {
        [dataDic setValue:phoneTextField.text forKey:@"account"];
    }
    if (pwdTextField.text && pwdTextField.text.length>0) {
        [dataDic setValue:pwdTextField.text forKey:@"password"];
    }
    [datacontrol loginPushData:dataDic andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:[self->datacontrol.dicLogin objectForKey:@"userinfo"]];
            [loginUser saveUser];
            //成功登录
            [Util changeRootVC];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
}
#pragma mark - 切换登录方式页面
- (void)showOrHiddenPwdBtnOnTouch:(UIButton*)btn {
    UIView *superView = btn.superview;
    UITextField *pwdTextField = (UITextField*)[superView viewWithTag:101];
    if (pwdTextField.secureTextEntry) {
        pwdTextField.secureTextEntry = NO;
        
        UIImage *showOrHiddenPwdImage = [UIImage imageNamed:@"login_password_display"];
        //UIImageRenderingModeAlwaysOriginal这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
        showOrHiddenPwdImage = [showOrHiddenPwdImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //setImage 是会渲染的
        [btn setImage:showOrHiddenPwdImage forState:UIControlStateNormal];
        showOrHiddenPwdImage = [UIImage imageNamed:@"login_password_display"];
        showOrHiddenPwdImage = [showOrHiddenPwdImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:showOrHiddenPwdImage forState:UIControlStateHighlighted];
        
    } else {
        pwdTextField.secureTextEntry = YES;
        
        UIImage *showOrHiddenPwdImage = [UIImage imageNamed:@"login_password_hide"];
        //UIImageRenderingModeAlwaysOriginal这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
        showOrHiddenPwdImage = [showOrHiddenPwdImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //setImage 是会渲染的
        [btn setImage:showOrHiddenPwdImage forState:UIControlStateNormal];
        showOrHiddenPwdImage = [UIImage imageNamed:@"login_password_hide"];
        showOrHiddenPwdImage = [showOrHiddenPwdImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:showOrHiddenPwdImage forState:UIControlStateHighlighted];
    }
}


- (void)zaloLoginBtnOnTouch {
    
    WEAK_SELF;
    [[ZaloSDK sharedInstance] authenticateZaloWithAuthenType:ZAZAloSDKAuthenTypeViaZaloAppAndWebView parentController:self
        handler:^(ZOOauthResponseObject *response) {
            if([response isSucess]) {
                
                //zalo_id zali用户编号
                //picture zalo头像
                //gender zalo性别
                //zalo_name zalo昵称
                //birthday 生日
                
                NSMutableDictionary *zalopram = [[NSMutableDictionary alloc]init];
                [zalopram setValue:response.userId forKey:@"zalo_id"];
                [zalopram setValue:response.displayName forKey:@"zalo_name"];
                [zalopram setValue:@"" forKey:@"picture"];
                [zalopram setValue:response.gender forKey:@"gender"];
                [zalopram setValue:response.dob forKey:@"birthday"];
                self->strotherNickName = response.displayName;
                [self thirdLogin:2 withBindCode:response.userId];
              
            } else{
                
                
            }
    }];
    
}

- (void)facebookLoginBtnOnTouch{
    
    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {

        NSLog(@"uid=%@",user.uid);
        NSLog(@"%@",user.credential);
        NSLog(@"token=%@",user.credential.token);
        NSLog(@"nickname=%@",user.nickname);

        NSMutableDictionary *rowData = [user.rawData mutableCopy];
        NSString *unionid = [rowData objectForKey:@"unionid"];

        NSString *openid = [rowData objectForKey:@"openid"];

        user.credential.token = openid;

        self->ssdkUser = user;
        self->strotherNickName = user.nickname;
        [self thirdLogin:1 withBindCode:unionid];
        
    };
    [tpl loginWechat];
    
}

//- (void)qqLoginBtnOnTouch:(UIButton*)btn {
//
//    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
//    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {
//
//        NSLog(@"uid=%@",user.uid);
//        NSLog(@"%@",user.credential);
//        NSLog(@"token=%@",user.credential.token);
//        NSLog(@"nickname=%@",user.nickname);
//
//        ssdkUser = user;
//
//        [self thirdLogin:[NSNumber numberWithInteger:1] withBindCode:user.uid];
//
//    };
//    [tpl loginQQ];
//}
//
//- (void)weiboLoginBtnOnTouch:(UIButton*)btn {
//
//    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
//    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {
//
//        NSLog(@"uid=%@",user.uid);
//        NSLog(@"%@",user.credential);
//        NSLog(@"token=%@",user.credential.token);
//        NSLog(@"nickname=%@",user.nickname);
//
//        ssdkUser = user;
//
//        [self thirdLogin:[NSNumber numberWithInteger:3] withBindCode:user.uid];
//
//    };
//    [tpl loginSina];
//
//}

#pragma mark - ///第三方登录绑定 (1:fb 2:zlao 3手机号(无效) 4apple)
- (void)thirdLogin:(NSInteger)type withBindCode:(NSString*)bindCode {
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    if(type == 1)
    {
        [dicpush setObject:@"facebook" forKey:@"platform"];
    }
    else if(type == 2)
    {
        [dicpush setObject:@"zalo" forKey:@"platform"];
    }
    else if(type == 3)
    {
        [dicpush setObject:@"sms" forKey:@"platform"];
        return;
    }
    else if(type == 4)
    {
        [dicpush setObject:@"apple" forKey:@"platform"];
    }
    
    [dicpush setObject:bindCode forKey:@"code"];
    
    [datacontrol otherLoginPushData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       
        if(state)
        {
            NSDictionary *dicdata = self->datacontrol.dicOtherLogin;
            if(type == 4)
            {
                if([[dicdata objectForKey:@"userinfo"] isKindOfClass:[NSDictionary class]])
                {
                    LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:[dicdata objectForKey:@"userinfo"] ];
                    [loginUser saveUser];
                    //成功登录
                    [Util changeRootVC];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"networkCancle", nil)];
                }
                return;
            }
            
            if([[dicdata objectForKey:@"code"] intValue] == 1)
            {
                if([[dicdata objectForKey:@"userinfo"] isKindOfClass:[NSDictionary class]])
                {
                    LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:[dicdata objectForKey:@"userinfo"] ];
                    [loginUser saveUser];
                    //成功登录
                    [Util changeRootVC];
                }
                else
                {
                    BindingVC *rvc = [[BindingVC alloc] init];
                    NSDictionary *dictemp = @{@"code":[dicpush objectForKey:@"code"],@"platform":[dicpush objectForKey:@"platform"]};
                    rvc.isbangding = YES;
                    rvc.dicBangDing = dictemp;
                    rvc.strnickname = self->strotherNickName;
                    [self.navigationController pushViewController:rvc animated:YES];
                }
            }
            else
            {
                BindingVC *rvc = [[BindingVC alloc] init];
                NSDictionary *dictemp = @{@"code":[dicpush objectForKey:@"code"],@"platform":[dicpush objectForKey:@"platform"]};
                rvc.isbangding = YES;
                rvc.dicBangDing = dictemp;
                rvc.strnickname = self->strotherNickName;
                [self.navigationController pushViewController:rvc animated:YES];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
            
        }
        
    }];
    
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"111",@"22",@"33"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height) imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = NO;
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark - 设置APP动态图片引导页
- (void)setDynamicGuidePage {
    NSArray *imageNameArray = @[@"guideImage6.gif",@"guideImage7.gif",@"guideImage8.gif"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height) imageNameArray:imageNameArray buttonIsHidden:YES];
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark --- appid登录
- (void)didAppleAction {
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
    
}

#pragma mark - ASAuthorizationControllerDelegate

/// Apple登录授权出错
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
    [SVProgressHUD showErrorWithStatus:errorMsg];
}

/// Apple登录授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    Class credentialClass = [authorization.credential class];
    if (credentialClass == [ASAuthorizationAppleIDCredential class]) {
        // 用户登录使用的是: ASAuthorizationAppleIDCredential,授权成功后可以取到苹果返回的全部数据,然后再与后台交互
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        NSString *userID = credential.user;
//        NSString *state = credential.state;
//        NSArray<ASAuthorizationScope> *authorizedScopes = credential.authorizedScopes;
//        // refresh_token
//        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
//        // access_token
//        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
//        NSString *email = credential.email;
//        NSPersonNameComponents *fullName = credential.fullName;
//        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        @try {
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"appleUserID"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
//        NSLog(@"Apple登录_1_user: %@", userID);
//        NSLog(@"Apple登录_4_authorizationCode: %@", authorizationCode);
//        NSLog(@"Apple登录_5_identityToken: %@", identityToken);
//        NSLog(@"Apple登录_6_email: %@", email);
//        NSLog(@"Apple登录_7_fullName.givenName: %@", fullName.givenName);
//        NSLog(@"Apple登录_7_fullName.familyName: %@", fullName.familyName);
//        NSLog(@"Apple登录_8_realUserStatus: %ld", realUserStatus);
        //这里我只用到了userID，email，[NSString stringWithFormat:@"%@%@", fullName.familyName, fullName.givenName]
       //接下来就调用自己服务器接口
        strotherNickName = @"";
        [self thirdLogin:4 withBindCode:userID];
        
        
    } else if (credentialClass == [ASPasswordCredential class]) {
        // 用户登录使用的是: 现有密码凭证
        ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
        NSString *user = credential.user; // 密码凭证对象的用户标识(用户的唯一标识)
        NSString *password = credential.password;
        NSLog(@"Apple登录_现有密码凭证: %@, %@", user, password);
        strotherNickName = @"";
        [self thirdLogin:4 withBindCode:user];
        
    }
}

#pragma mark - 设置APP视频引导页
- (void)setVideoGuidePage {
    
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guideMovie1" ofType:@"mov"]];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height) videoURL:videoURL];
    [self.navigationController.view addSubview:guidePage];
}
//// 用户协议
//- (void)userAgreementBtnOnTouch:(id)sender {
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@/agreement.html?type=2", H5ADDR];
////    WebViewVC *vc = [[WebViewVC alloc] initWithTitle:@"58使用协议及声明" andUrl:urlStr];
////    [self.navigationController pushViewController:vc animated:YES];
//
//}

- (void)forgetPwdBtnOnTouch:(id)sender {
    LoginForgetPwdVC *vc = [[LoginForgetPwdVC alloc] initWithNibName:@"LoginForgetPwdVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 100) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

#pragma mark -- 语言切换

- (void)setAppLanguage:(UIButton*)btn {
    
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    if((btn.tag==0 && [userSettingLanguage isEqualToString:@"vi"])||(btn.tag == 1 && [userSettingLanguage isEqualToString:@"zh-Hans"]))
    {
        return;
    }
    
    switch (btn.tag) {
        case 0:
            [UWConfig setUserLanguage:@"vi"];
            break;
        case 1:
            [UWConfig setUserLanguage:@"zh-Hans"];
            break;
            
        default:
            break;
    }
    
    for (UIButton *btn in languageArr) {
        [btn setSelected:NO];
    }
    [btn setSelected:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"addressListHome"];
    
    //更新UI
//    UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    
//    NSUInteger tabbarSelectedIndex = tabBar.selectedIndex;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //解决奇怪的动画bug。异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:[self exitAnim] forKey:nil];
        
        [app createRootVC];
        
        UITabBarController *newTabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        newTabBar.selectedIndex = 0;
        [Util LoginVC:YES];
        
    });
}

- (CAAnimation*)exitAnim {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3f];
    animation.type = @"fade";
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}



@end
