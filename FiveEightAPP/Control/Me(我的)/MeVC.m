#import "MeVC.h"
#import "XSZStretchableTableHeaderView.h"
#import "WalletVC.h"
#import "ShareWebViewVC.h"
#import "SettingVC.h"


#import "MyCollectVC.h"

#define StretchHeaderHeight 170

@interface MeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    XSZStretchableTableHeaderView *stretchHeaderView;
    
    UIImageView *headImageView;
    UILabel *nickNameLabel;
//    UIImageView *phoneImageView;
    UILabel *phoneOrDescLabel;
    
    NSArray *imageNameArr;
    NSArray *textArr;
    NSArray *classNameArr;
    
    UILabel *personalInfoLabel;
    
    UIView *viewnavline;
}
@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mPageName = @"我的";
    
    //注册登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:@"LoginStatusChange" object:nil];
    
//    [self setNavigationBarTitle:nil leftImage:nil andRightImage:[UIImage imageNamed:@"me_icon_set"]];
    [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
    

    [self initWithRefreshTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-49)];

    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self initStretchHeader];
    
//
    textArr = @[@[NSLocalizedString(@"mycollect", nil), NSLocalizedString(@"publicHestory", nil),NSLocalizedString(@"regionalPartner", nil),NSLocalizedString(@"myCertification", nil)],@[NSLocalizedString(@"feedback", nil), NSLocalizedString(@"customerTelephone", nil),NSLocalizedString(@"setUp", nil)]];
    imageNameArr = @[ @[@"collect_yes", @"my_public_hestory", @"my_quyu_hehuoren", @"my_woderenzhen"],@[@"my_yijianfankui", @"my_upphone", @"my_set"]];
    classNameArr = @[@[@"MyCollectVC", @"PublishHistoryVC",@"RegionalPartnersVC",@"StoreAuthVC"], @[@"ApplyAgentVC", @"FeedbackVC",@"SettingVC"]];
    
    
    viewnavline = [[UIView alloc] init];
    [viewnavline setBackgroundColor:RGB(240, 240, 240)];
    [self.navigationController.navigationBar addSubview:viewnavline];
    [viewnavline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigationController.navigationBar);
        make.height.offset(1);
    }];
    [viewnavline setHidden:YES];
    
}

#pragma mark - 头部设置点击
-(void)navSetAction
{
    SettingVC *rvc = [[SettingVC alloc] init];
    rvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)initStretchHeader
{
    //背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, StretchHeaderHeight-64+SafeAreaTopHeight)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    bgImageView.image = [UIImage imageNamed:@"nav_bg"];
    
    //背景之上的内容
    UIView *contentView = [[UIView alloc] initWithFrame:bgImageView.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    
    
    NSString *headImage = [User sharedUser].headImage;
    if(![headImage hasPrefix:@"http://"] && ![headImage hasPrefix:@"https://"]) {
        headImage = [NSString stringWithFormat:@"%@%@",IMAGEPREFIX,headImage];
    }
    
    headImageView = [[UIImageView alloc] init];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
    [headImageView.layer setMasksToBounds:YES];
    [headImageView.layer setCornerRadius:30.0f];
    [headImageView.layer setBorderWidth:2.5f];
    [headImageView.layer setBorderColor:[UIColor clearColor].CGColor];
    [contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(contentView);
        make.bottom.equalTo(contentView).with.offset(-((StretchHeaderHeight-20-70)/2.0));
        make.left.equalTo(contentView).with.offset(20);
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@60);
    }];
    
    UIImageView *accessoryDisclosureIndicatorImageView = [[UIImageView alloc] init];
    accessoryDisclosureIndicatorImageView.image = [UIImage imageNamed:@"ic_stat_left_nn"];
    [contentView addSubview:accessoryDisclosureIndicatorImageView];
    [accessoryDisclosureIndicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImageView);
        make.right.equalTo(contentView).with.offset(-20);
        make.height.mas_equalTo(@24);
        make.width.mas_equalTo(@24);
    }];
    
    personalInfoLabel = [[UILabel alloc]init];
    personalInfoLabel.font = [UIFont systemFontOfSize:13];
    personalInfoLabel.textColor = [UIColor whiteColor];
    personalInfoLabel.textAlignment = NSTextAlignmentRight;
//    personalInfoLabel.text = NSLocalizedString(@"personalInformation", nil);
    [contentView addSubview:personalInfoLabel];
    [personalInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImageView);
        make.right.equalTo(contentView).with.offset(-42);
        make.height.mas_equalTo(@24);
        make.width.mas_equalTo(@75);
    }];
    
    
    nickNameLabel = [[UILabel alloc]init];
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    nickNameLabel.textColor = [UIColor whiteColor];
    
    [contentView addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.left.equalTo(headImageView.mas_right).with.offset(15);
        make.right.equalTo(accessoryDisclosureIndicatorImageView.mas_left).with.offset(-16);
        make.height.mas_equalTo(@40);
    }];
    
    phoneOrDescLabel = [[UILabel alloc]init];
    phoneOrDescLabel.font = [UIFont systemFontOfSize:15];
    phoneOrDescLabel.textColor = [UIColor whiteColor];
//    phoneOrDescLabel.text = @"139****7518";
    [contentView addSubview:phoneOrDescLabel];
    [phoneOrDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->headImageView.mas_bottom);
        make.left.equalTo(self->nickNameLabel);
        make.right.equalTo(accessoryDisclosureIndicatorImageView.mas_left).with.offset(-16);
        make.height.mas_equalTo(@30);
    }];
    
//    phoneImageView = [[UIImageView alloc]init];
//    phoneImageView.image = [UIImage imageNamed:@"me_icon_cell"];
//    [contentView addSubview:phoneImageView];
//    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(phoneOrDescLabel);
//        make.left.equalTo(headImageView.mas_right).with.offset(15);
//        make.right.equalTo(phoneOrDescLabel.mas_left).with.offset(-6);
//        make.height.mas_equalTo(@14);
//        make.width.mas_equalTo(@14);
//    }];
    
    
    UIButton *stretchHeaderViewBtn = [[UIButton alloc] init];
    [stretchHeaderViewBtn addTarget:self action:@selector(stretchHeaderViewBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:stretchHeaderViewBtn];
    [stretchHeaderViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView).with.offset(20);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.bottom.equalTo(contentView.mas_bottom);
        
    }];
    
    
//    UIButton *btset = [[UIButton alloc] initWithFrame:CGRectMake(bgImageView.width-60, SafeAreaTopHeight-40, 50, 40)];
//    [btset setImage:[UIImage imageNamed:@"me_icon_set"] forState:UIControlStateNormal];
//    [btset addTarget:self action:@selector(navSetAction) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:btset];
    
    
    
    stretchHeaderView = [XSZStretchableTableHeaderView new];
    [stretchHeaderView stretchHeaderForTableView:self.tableView withView:bgImageView subViews:contentView];
    
}

- (void)stretchHeaderViewBtnOnTouch:(id)sender {
    
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    Class someClass = NSClassFromString(@"PersonalInfoVC");
    UIViewController *vc = [[someClass alloc] initWithNibName:@"PersonalInfoVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [viewnavline setHidden:YES];
//    [self setNavigationBarTitle:nil leftImage:nil andRightImage:[UIImage imageNamed:@"me_icon_set"]];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSLog(@"StatusBar:3白");
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:YES];
    
    [self updateView];
    
}


- (void)updateView {
    

    if ([User isNeedLogin]) {
        //未登录
        personalInfoLabel.hidden = YES;
        headImageView.image = [UIImage imageNamed:@"avater"];
        nickNameLabel.text = NSLocalizedString(@"ImmediatelyLogin", nil);
        phoneOrDescLabel.text = NSLocalizedString(@"ImmediatelyLoginComtent", nil);
//        [phoneImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@0);
//        }];
        [phoneOrDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->headImageView.mas_right).with.offset(15);
        }];
    } else {
        //已登录
        NSString *headImage = [User sharedUser].headImage;
        if(![headImage hasPrefix:@"http://"] && ![headImage hasPrefix:@"https://"]) {
            headImage = [NSString stringWithFormat:@"%@%@",IMAGEPREFIX,headImage];
        }
        [headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
        nickNameLabel.text = [User sharedUser].nickname;
        phoneOrDescLabel.text = [Util getConcealPhoneNumber:[User sharedUser].phone];
        personalInfoLabel.hidden = NO;
        
//        [phoneImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@14);
//        }];
        
        [phoneOrDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->nickNameLabel);
        }];
        
        [self getUserInfo];
    }
    
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSLog(@"StatusBar:3黑");
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
//    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
    [viewnavline setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo {
    
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:SUCCESS]) {
                
//                UserInfo *user = [UserInfo mj_objectWithKeyValues:rd.data];
                
                
//                [User sharedUser].user_id = user.id;
//                [User sharedUser].nickname = user.nick;
//                [User sharedUser].sex = user.sex;
//                [User sharedUser].phone = user.telphone;
//                [User sharedUser].headImage = user.avatar;
//                [User sharedUser].create_date = @"";
//                [User sharedUser].platform = @"";
//                [User sharedUser].brithday = user.birthDate;
//                [User sharedUser].userType = user.type;
//                [User sharedUser].userStatus = user.status;
//                [User sharedUser].isSetLoginPwd = user.haspassword;
//                [User sharedUser].isSetPayPwd = user.haspaypassword;
//                [User sharedUser].score = user.pointerCount;
//                [User sharedUser].coupon = user.couponCount;
//                [User sharedUser].money = user.accountAmount;
//                [User sharedUser].isBindQQ = user.bindinfo.qq;
//                [User sharedUser].isBindWX = user.bindinfo.weixin;
//                [User sharedUser].isBindWB = user.bindinfo.weibo;
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
                [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.tableView reloadData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.sub_msg];
            }
        });
    };
    [hm getRequetInterfaceData:nil withInterfaceName:@"user/userinfo"];
    
}

//- (void)getScore {
//
//    HttpManager *hm = [HttpManager createHttpManager];
//
//    hm.responseHandler = ^(id responseObject) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
//
//            if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:SUCCESS]) {
//
//                MyScore *myScore = [MyScore mj_objectWithKeyValues:rd.data];
//
//                [User sharedUser].score = [NSNumber numberWithInteger:[myScore.integral integerValue]];
//                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
//                [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                [self.tableView reloadData];
//
//                NSLog(@"");
//
//            } else {
//                [SVProgressHUD showErrorWithStatus:rd.sub_msg];
//            }
//        });
//    };
//    [hm getRequetInterfaceData:nil withInterfaceName:@"user/userinfo"];
//}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CustomCellIdentifier];
    }
    
    cell.textLabel.textColor = COL2;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    cell.detailTextLabel.textColor = COL2;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    cell.textLabel.text = [[textArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *imageName = [[imageNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setHeight:48];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 0.0000001;
    }
    return DEFAULTSECTIONALIGNHEIGHT;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0)
    {
        if(indexPath.row <= 3)
        {
            if ([User isNeedLogin]) {
                [Util LoginVC:YES];
                return;
            }
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row <= 1)
        {
            if ([User isNeedLogin]) {
                [Util LoginVC:YES];
                return;
            }
        }
    }
    
    NSString *className = [[classNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([className isEqualToString:@"FeedbackVC"])
    {///客服电话
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", [User sharedUser].linksys];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//        });
        return;
    }
    Class someClass = NSClassFromString(className);
    UIViewController *vc = [[someClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

/**
 *  分割线的处理
 */
-(void)viewDidLayoutSubviews
{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [stretchHeaderView resizeView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }

    
    
}

#pragma mark - stretchableTable delegate
/**
 *  滚动UIScrollView改变导航栏背景颜色和title
 *
 *  @param scrollView UIScrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset < 201) {
        
        [self setNavigationBarTitle:nil leftImage:nil andRightImage:[UIImage imageNamed:@"me_icon_set"]];
        [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:YES];
        
    } else {
        
        [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:DEFAULTCOLOR1 andIsShowSplitLine:NO];
        self.navigationController.navigationBar.titleTextAttributes = @{
                                                                        UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:18]
                                                                        };
    }
    
    [stretchHeaderView scrollViewDidScroll:scrollView];
}

- (void)loginStatusChange:(NSNotification *)notification {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: notification.object];
    BOOL loginStatus = [[dic valueForKey:@"LoginStatus"] boolValue];
    
    if (loginStatus) {
        
    } else {
        
    }
}

#pragma mark --

- (void)moneyBtnOnTouch:(id)sender {
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    WalletVC *vc = [[WalletVC alloc] initWithNibName:@"WalletVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scoreBtnOnTouch:(id)sender {
//
//    if ([User isNeedLogin]) {
//        [Util LoginVC:YES];
//        return;
//    }
//
//    MyScoreVC *vc = [[MyScoreVC alloc] initWithNibName:@"MyScoreVC" bundle:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)couponBtnOnTouch:(id)sender {
//
//    if ([User isNeedLogin]) {
//        [Util LoginVC:YES];
//        return;
//    }
//
//    MyCouponContainerVC *vc = [[MyCouponContainerVC alloc] initWithNibName:@"MyCouponContainerVC" bundle:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 通知更新



#pragma mark --


- (void)rightBtnOnTouch:(id)sender {
    
    SettingVC *vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
