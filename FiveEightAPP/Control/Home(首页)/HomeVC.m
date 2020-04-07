//
//  HomeVC.m
//  FiveEight
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "HomeVC.h"

#import "FEHorizontalMenuView.h"
#import "CCPScrollView.h"
#import "FECycleScrollView.h"
#import "LocalImageCell.h"
#import "FEClassifyCollectionView.h"
#import "ClassifyDataListVC.h"
#import "OpenedCityVC.h"
#import "ColumnTypeObj.h"

#import "MDBEmptyView.h"

#import "HomeDataControl.h"
#import "HomeLanMuModel.h"
#import "HomeBanKuaiItemVC.h"

#import "ContentDetailVC.h"
#import "WebViewVC.h"
#import "HomeBanKuaiVC.h"
#import "HomeSearchVC.h"
#import "LoginUser.h"
#import "PublishTypeVC.h"

#import "XieYiAlterView.h"
#import "AppDelegate.h"

#define BOOLFORKEY @"dhGuidePage"

static NSString *kLocalCellId = @"LocalImageCell";

@interface HomeVC ()<FEHorizontalMenuViewDelegate,FEHorizontalMenuViewDataSource,FEClassifyCollectionViewDelegate>
{
    UIButton *cityBtn;
    
    TPKeyboardAvoidingScrollView *scrollView;
    UIView *topView;
    float bgViewHeight;
    CCPScrollView *ccpHotPointView;
    CCPScrollView *ccppopularView;
    UIView *hotNewsView;
    UIView *adView;
    
    NSArray *allTypeArr;
    
    
    HomeDataControl *datacontrol;
    ///
    NSMutableArray *arrLanMu;
    NSMutableArray *arrHotLanMu;
    
    ///是否获取到了数据
    BOOL isgetdata;
    BOOL isloaddata;
    
    BOOL isuserinfo;
    ///是否可以跳转
    BOOL isPush;
    
}
@property (nonatomic,strong) FEHorizontalMenuView *typeMenuView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic, strong) NSArray *localPathGroup;
@property (nonatomic, strong) FECycleScrollView *cycleScrollView;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong)FEClassifyCollectionView *classifyView;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mPageName = @"首页";
//    [self setNavigationBarTitle:NSLocalizedString(@"Home", nil) leftImage:nil andRightImage:nil];
//    NSString *accessTokenInterval = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenInterval"];
//    NSString *currentInterval = [Util currentDateInterval];
    
    
    datacontrol = [HomeDataControl new];
    [self initView];
    
    ///绘制没得网络的页面
    [self emptyView];
    
    [self newtworkJianting];
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowGuideRootVC"];
        [Util LoginVC:YES];
        return;
    }
    
    
}
///协议弹框
-(void)yingshixieyi
{
    NSString *strtemp = [NSString nullToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"58tongyixieyi"]];
    //////
    if([strtemp intValue] != 2)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
            XieYiAlterView *alterview = [[XieYiAlterView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height) andtitle:nil andcontent:nil];
            alterview.nav = self.navigationController;
            [dele.tabBarCtrl.view addSubview:alterview];
        });
    }
}


-(void)newtworkJianting
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    switch (status) {
    case AFNetworkReachabilityStatusUnknown:
        {
            NSLog(@"未识别的网络");
            [self->_emptyView setHidden:NO];
        }
    break;

    case AFNetworkReachabilityStatusNotReachable:
        {
           NSLog(@"不可达的网络(未连接)");
            [self->_emptyView setHidden:NO];
        }

    break;

    case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [self->_emptyView setHidden:YES];
            
            [self initData];
//            if(self->isgetdata==NO&&self->isloaddata == YES)
//            {
//
//
//            }
            
        }
    break;

    case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self->_emptyView setHidden:YES];
            [self initData];
//            if(self->isgetdata==NO&&self->isloaddata == YES)
//            {
//                [self initData];
//            }
        }

    break;

    default:

    break;

    }
    }];
    [manager startMonitoring];
    
}

- (void)initData {
    
    [self setAddressButtonValue];
    
    isloaddata = YES;
    
    [self getLanMu];
    [self getLunBoImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getNewMessage];
        [self getHotLanMu];
    });
    
    
}

-(void)getLanMu
{
    
    NSMutableDictionary *dicPush = [NSMutableDictionary new];
    
    [datacontrol homeLanMuData:dicPush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self->scrollView.mj_header endRefreshing];
        self->arrLanMu = [NSMutableArray new];
        if(state)
        {
            self->isgetdata = YES;
            for(NSDictionary *dic in self->datacontrol.arrLanMu)
            {
                HomeLanMuModel *model = [HomeLanMuModel dicToModelValue:dic];
                [self->arrLanMu addObject:model];
                self->_typeArr = self->arrLanMu;
                
            }
        }
        [self.typeMenuView reloadData];
        
    }];
    
}

-(void)getLunBoImage
{
    NSMutableDictionary *dicPush = [NSMutableDictionary new];
    [datacontrol homeLunBoImageData:dicPush andshowView:nil Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->isgetdata = YES;
            self->_localPathGroup = self->datacontrol.arrLunBoImage;
        }
        [self->_cycleScrollView reloadData];
        
    }];
}

-(void)getNewMessage
{
    NSMutableDictionary *dicPush = [NSMutableDictionary new];
    [dicPush setObject:[NSString stringWithFormat:@"%@",_oc.id] forKey:@"cityid"];
    [datacontrol homeNewMessageData:dicPush andshowView:nil Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       
        if(state)
        {
            self->isgetdata = YES;
            NSMutableArray *arrtemp = [NSMutableArray new];
            for(NSDictionary *dic in self->datacontrol.arrNewMessage)
            {
                [arrtemp addObject:[NSString nullToString:[dic objectForKey:@"title"]]];
            }
            self->ccpHotPointView.titleArray = arrtemp;
            
            
        }
        
    }];
}

-(void)getHotLanMu
{
    NSMutableDictionary *dicPush = [NSMutableDictionary new];
    [datacontrol hotLanMuData:dicPush andshowView:nil Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->isgetdata = YES;
            self->bgViewHeight -= self->_classifyView.height;
            self->arrHotLanMu = [NSMutableArray arrayWithArray:self->datacontrol.arrhotLanMu];
            self->_classifyView.dataArr = self->arrHotLanMu;
            self->bgViewHeight += self->_classifyView.height;
            [self->_bgView setHeight:self->bgViewHeight];
            self->scrollView.contentSize = CGSizeMake(DEVICE_Width, self->bgViewHeight);
            
        }
    }];
}
///拉取用户信息
-(void)getUserInfoData
{
    if([User isNeedLogin])return;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [datacontrol userInfoData:dicpush andshowView:nil Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->isuserinfo = YES;
            
            LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:self->datacontrol.userinfoData];
            [loginUser saveUser];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    isPush = YES;
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
    [self setAddressButtonValue];
    
    if(isuserinfo==NO)
    {
        [self getUserInfoData];
    }
    
    [self yingshixieyi];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:YES];
}

- (void)setNavItem {
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 73, 24)];
    titleImageView.image = [UIImage imageNamed:@"tabbar_add_yellow"];
    self.navigationItem.titleView = titleImageView;
    
}
-(void)setAddressButtonValue
{
    
    NSString *strid = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYID];
    NSString *strname = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYNAME];
    if(strname.length<1)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"henei", nil) forKey:SELECTCITYNAME];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:SELECTCITYID];
        strid = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYID];
        strname = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYNAME];
    }
    _oc = [[OpenedCity alloc] init];
    _oc.name =strname;
    _oc.id = [NSNumber numberWithInteger:[strid integerValue]];
    
    if(cityBtn)
    {
        [cityBtn setTitle:_oc.name forState:UIControlStateNormal];
        [cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateNormal];
        [cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateHighlighted];
        [cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
    }
}



- (void)initView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-tabBarHeight)];
    scrollView.contentSize = (CGSize){DEVICE_Width,scrollView.height};
    scrollView.delegate      = self;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:self.bgView];
    
    
    UIView *viewtopback = [[UIView alloc] init];
    [self.bgView addSubview:viewtopback];
    [viewtopback setClipsToBounds:YES];
    [viewtopback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.offset(DEVICE_Width);
//        make.height.offset(100);
    }];
    UIView *viewcolor = [[UIView alloc] init];
    [viewcolor setBackgroundColor:RGB(234, 58, 60)];
    [viewtopback addSubview:viewcolor];
    [viewcolor.layer setMasksToBounds:YES];
    [viewcolor.layer setCornerRadius:1000];
    [viewcolor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewtopback);
        make.bottom.equalTo(viewtopback);
        make.size.sizeOffset(CGSizeMake(2000, 2000));
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGB(234, 58, 60);
    [self.bgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusBarHeight);
        make.left.offset(0);
        make.width.offset(DEVICE_Width);
        make.height.offset(50);
    }];
    [self drawTopView:topView];
    bgViewHeight = kStatusBarHeight+50;
    
    [viewtopback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_bottom).offset(40);
    }];
    
    
    [self createTypeMenuView];
    
    [_bgView setHeight:bgViewHeight];
    scrollView.contentSize = CGSizeMake(DEVICE_Width, bgViewHeight);
     
    
}
#pragma mark - 顶部搜索区域
-(void)drawTopView:(UIView *)view
{
    UIImageView *flogImageView = [[UIImageView alloc] init];
    flogImageView.image = [UIImage imageNamed:@"log_log"];
    [view addSubview:flogImageView];
    [flogImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(12);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setTitle:NSLocalizedString(@"pushPublic", nil) forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:[UIColor clearColor]];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [publishBtn addTarget:self action:@selector(publishBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.bottom.equalTo(view);
        make.width.offset(40);
    }];
    
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 60, 40)];
    [cityBtn setTitle:_oc.name forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setBackgroundColor:[UIColor clearColor]];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateHighlighted];
    [cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [cityBtn addTarget:self action:@selector(cityBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cityBtn];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setTitle:NSLocalizedString(@"zhaogongzuozhaofangz", nil) forState:UIControlStateNormal];
    [searchBtn setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGBA(255, 255, 255, 1)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setImage:[UIImage imageNamed:@"searchBar_icon"] forState:UIControlStateNormal];
    [searchBtn.layer setCornerRadius:3.0f];
    [searchBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [searchBtn addTarget:self action:@selector(searchBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->cityBtn.mas_right);
        make.right.equalTo(publishBtn.mas_left);
        make.top.offset(10);
        make.height.offset(30);
    }];
}
///模块
- (void)createTypeMenuView {
    
    self.typeMenuView = [[FEHorizontalMenuView alloc]initWithFrame:CGRectMake(15, 0, DEVICE_Width-30, 190)];
    self.typeMenuView.tag = 1000;
    self.typeMenuView.delegate = self;
    self.typeMenuView.dataSource = self;
    self.typeMenuView.backgroundColor = [UIColor whiteColor];
    self.typeMenuView.currentPageDotColor = RGB(234, 58, 60);
    self.typeMenuView.pageDotColor = RGB(200, 200, 200);
    [self.typeMenuView.layer setMasksToBounds:NO];
    [self.typeMenuView.layer setCornerRadius:5];
    [self.bgView addSubview:self.typeMenuView];
    [self.typeMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusBarHeight+50);
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-30, 190));
    }];
    self.typeMenuView.layer.shadowColor = RGB(180, 180, 180).CGColor;
    self.typeMenuView.layer.shadowOpacity = 0.8f;
    self.typeMenuView.layer.shadowRadius = 4.0f;
    self.typeMenuView.layer.shadowOffset = CGSizeMake(0,2);
    
    bgViewHeight += 190;
    
    [self createHotNewsView];
}
#pragma mark - 最新消息
- (void)createHotNewsView {
    
    hotNewsView = [[UIView alloc] init];
    hotNewsView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:hotNewsView];
    [hotNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeMenuView.mas_bottom).with.offset(10);
        make.left.equalTo(self.bgView).with.offset(0);
        make.right.equalTo(self.bgView).with.offset(0);
        make.height.mas_equalTo(@80);
    }];

    UILabel *leftImageView = [[UILabel alloc] init];
    [leftImageView setText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"zuixin", nil),NSLocalizedString(@"Message", nil)]];
    [leftImageView setTextColor:RGB(223, 66, 71)];
    [leftImageView setNumberOfLines:2];
    [leftImageView setTextAlignment:NSTextAlignmentCenter];
    [leftImageView setFont:[UIFont boldSystemFontOfSize:16]];
    [hotNewsView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->hotNewsView).with.offset(12);
        make.centerY.mas_equalTo(self->hotNewsView);
        make.size.mas_equalTo(CGSizeMake(40, 60));
    }];
    
    ccpHotPointView = [[CCPScrollView alloc] initWithFrame:CGRectMake(66, 13, DEVICE_Width-60-32, 50)];
    [hotNewsView addSubview:ccpHotPointView];
    ccpHotPointView.titleFont = 12;
    ccpHotPointView.titleColor = COL1;
    ccpHotPointView.BGColor = [UIColor whiteColor];
    [ccpHotPointView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        [self selectNewMessageIndex:index];
    }];
    
    bgViewHeight += 10+80;
    
    [self createAdView];
}
#pragma mark - 滚动广告图
- (void)createAdView {
    
    adView = [[UIView alloc] init];
    adView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:adView];
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotNewsView.mas_bottom).with.offset(0);
        make.left.equalTo(self.bgView).with.offset(0);
        make.right.equalTo(self.bgView).with.offset(0);
        make.height.mas_equalTo(@140);
    }];
    
    _cycleScrollView = [[FECycleScrollView alloc] initWithFrame:CGRectMake(0.f, 12.0f, DEVICE_Width, FIT_WIDTH(116.f))];
    _cycleScrollView.delegate = self;
    _cycleScrollView.dataSource = self;
    _cycleScrollView.hidesPageControl = YES;
    _cycleScrollView.itemSpacing = 12.f;
    _cycleScrollView.itemSize = CGSizeMake(DEVICE_Width - 24.f, _cycleScrollView.bounds.size.height);
    [_cycleScrollView registerCellNib:[UINib nibWithNibName:@"LocalImageCell" bundle:nil] forCellWithReuseIdentifier:kLocalCellId];
    [adView addSubview: _cycleScrollView];
    
    bgViewHeight += 140;
    
    [self createBathFullTimeClassifyView];
}
#pragma mark -快捷热门
- (void)createBathFullTimeClassifyView {
    
    UIView *classifyTitleView = [[UIView alloc] init];
    classifyTitleView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:classifyTitleView];
    [classifyTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->adView.mas_bottom).with.offset(0);
        make.left.equalTo(self.bgView).with.offset(0);
        make.right.equalTo(self.bgView).with.offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = REDCOLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = NSLocalizedString(@"hotPlate", nil);
    [classifyTitleView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(classifyTitleView).with.offset(0);
        make.left.equalTo(classifyTitleView).with.offset(18);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SEPARATORCOLOR;
    [classifyTitleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(classifyTitleView).with.offset(0);
        make.left.equalTo(classifyTitleView).with.offset(0);
        make.right.equalTo(classifyTitleView).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    bgViewHeight += 50;
    
    FEClassifyCollectionView *classifyView = [[FEClassifyCollectionView alloc] initWithFrame:CGRectMake(0, bgViewHeight, DEVICE_Width, 400)];
    classifyView.backgroundColor = REDCOLOR;
    [classifyView setDelegate:self];
    [self.bgView addSubview:classifyView];
    _classifyView = classifyView;
    
    bgViewHeight += classifyView.height;
}

#pragma mark - 搜索
-(void)searchBtnOnTouch
{
    if(isPush==NO)return;
    isPush=NO;
    HomeSearchVC *hvc = [[HomeSearchVC alloc] init];
    hvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hvc animated:YES];
    
}

#pragma mark - 发布
-(void)publishBtnOnTouch
{
    if(isPush==NO)return;
    isPush=NO;
    
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    PublishTypeVC *vc = [[PublishTypeVC alloc] initWithNibName:@"PublishTypeVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:^{

    }];
}

#pragma mark - 最新消息点击
-(void)selectNewMessageIndex:(NSInteger)index
{
    if(isPush==NO)return;
    isPush=NO;
    
    NSDictionary *dic = datacontrol.arrNewMessage[index];
    
    ContentDetailVC *dvc = [[ContentDetailVC alloc] init];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.contentId = [NSNumber numberWithInt:[[dic objectForKey:@"id"] intValue]];
    [self.navigationController pushViewController:dvc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- FEHorizontalMenuViewDataSource
/**
 提供数据的数量
 
 @param horizontalMenuView 控件本身
 @return 返回数量
 */
- (NSInteger)numberOfItemsInHorizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView{
    return arrLanMu.count;
}

#pragma mark --- FEHorizontalMenuViewDelegate
/**
 设置每页的行数 默认 2
 
 @param horizontalMenuView 当前控件
 @return 行数
 */
- (NSInteger)numOfRowsPerPageInHorizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView{
    return 2;
}

/**
 设置每页的列数 默认 4
 
 @param horizontalMenuView 当前控件
 @return 列数
 */
- (NSInteger)numOfColumnsPerPageInHorizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView{
    return 4;
}
/**
 当选项被点击回调
 
 @param horizontalMenuView 当前控件
 @param index 点击下标
 */
#pragma mark - 头部板块点击
- (void)horizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index{
    
//    ColumnTypeObj *cto = [self.typeArr objectAtIndex:index];
//
//    ClassifyDataListVC *vc= [[ClassifyDataListVC alloc] initWithNibName:@"ClassifyDataListVC" bundle:nil];
//    vc.cto = cto;
//    vc.oc = _oc;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    if(isPush==NO)return;
    isPush=NO;
    
    HomeLanMuModel *model = arrLanMu[index];
    HomeBanKuaiVC *hvc = [[HomeBanKuaiVC alloc] init];
    hvc.hidesBottomBarWhenPushed = YES;
    hvc.strid = model.did;
    hvc.strname = model.name;
    hvc.modelSuper = model;
    [self.navigationController pushViewController:hvc animated:YES];
    
}
/**
 当前菜单的title
 
 @param horizontalMenuView 当前控件
 @param index 下标
 @return 标题
 */
- (NSString *)horizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger)index{
    if (horizontalMenuView.tag == 1000) {
        
        ColumnTypeObj *cto = [self.typeArr objectAtIndex:index];
        return cto.name;
    }
    return @"求职";
}
/**
 网络图片
 
 @param horizontalMenuView 当前控件
 @param index 下标
 @return 图片名称
 */
- (NSURL *)horizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView iconURLForItemAtIndex:(NSInteger)index {
    ColumnTypeObj *cto = [self.typeArr objectAtIndex:index];
//    NSLog(@"图片地址：%@",cto.image);
    return [NSURL URLWithString:cto.image];
}

- (CGSize)iconSizeForHorizontalMenuView:(FEHorizontalMenuView *)horizontalMenuView{
    return CGSizeMake(45, 45);
}

#pragma mark -- FECycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(FECycleScrollView *)cycleScrollView {
    
    return _localPathGroup.count;
    
}

- (__kindof FECycleScrollViewCell *)cycleScrollView:(FECycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    
    LocalImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kLocalCellId forIndex:index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[_localPathGroup[index] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
    return cell;
    
}

#pragma mark -- ZKCycleScrollView Delegate 滚动图
- (void)cycleScrollView:(FECycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if(isPush==NO)return;
    isPush=NO;
    
    NSDictionary *dic = datacontrol.arrLunBoImage[index];
//    WebViewVC *wvc = [[WebViewVC alloc] initWithTitle:<#(NSString *)#> andUrl:<#(NSString *)#>]
    NSLog(@"selected index: %@", dic);
    
    WebViewVC *wvc = [[WebViewVC alloc] initWithTitle:[NSString nullToString:[dic objectForKey:@"title"]] andUrl:[NSString nullToString:[dic objectForKey:@"url"]]];
    wvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wvc animated:YES];
    
}

- (void)cycleScrollViewDidScroll:(FECycleScrollView *)cycleScrollView progress:(CGFloat)progress {
    
//    NSLog(@"content offset-x: %f", cycleScrollView.contentOffset.x);
    
}

- (void)cycleScrollView:(FECycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
//    NSLog(@"from %zd to %zd", fromIndex, toIndex);
    
    
    
}
#pragma mark - 热门板块代理
-(void)selectItemValue:(id)value
{
    if(isPush==NO)return;
    isPush=NO;
    
    NSDictionary *dic = value;
    HomeBanKuaiItemVC *bvc = [[HomeBanKuaiItemVC alloc] init];
    bvc.hidesBottomBarWhenPushed = YES;
    bvc.strid = [NSString nullToString:[dic objectForKey:@"id"]];
    bvc.strname = [NSString nullToString:[dic objectForKey:@"name"]];
    [self.navigationController pushViewController:bvc animated:YES];
}

#pragma mark --- 城市选择

- (void)cityBtnOnTouch {
    
    if(isPush==NO)return;
    isPush=NO;
    
    OpenedCityVC *vc = [[OpenedCityVC alloc] initWithNibName:@"OpenedCityVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.handler = ^(id  _Nonnull cityObj) {
        self->_oc = cityObj;
        [self->cityBtn setTitle:self->_oc.title forState:UIControlStateNormal];
        [self->cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateNormal];
        [self->cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateHighlighted];
        [self->cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:self->_oc.title] forKey:SELECTCITYNAME];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:self->_oc.id] forKey:SELECTCITYID];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark --

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
        [_emptyView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapemp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(initData)];
        [_emptyView addGestureRecognizer:tapemp];
    }
    return _emptyView;
}

@end
