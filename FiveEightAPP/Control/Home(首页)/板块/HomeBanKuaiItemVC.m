//
//  HomeBanKuaiItemVC.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeBanKuaiItemVC.h"
#import "HomeBanKuaiDataControl.h"
#import "BanKuaiModel.h"
#import "ContentDetailVC.h"
#import "HomeBanKuaiItemTableViewCell.h"
#import "OpenedCityVC.h"
#import "OpenedCity.h"

@interface HomeBanKuaiItemVC ()
{
    NSMutableArray *_dataArray;
    HomeBanKuaiDataControl *datacontrol;
    NSString *strcityid;
}
@property (nonatomic , retain) UIButton *cityBtn;
@end

@implementation HomeBanKuaiItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:_strname leftImage:[UIImage imageNamed:@"ic_stat_back_02_n"] andRightImage:nil];
    [self setNavRightBt];
        
    [self initWithRefreshTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.isShowWithoutDataView = YES;
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    datacontrol = [HomeBanKuaiDataControl new];
    strcityid = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYID];
    [self loadFirstData];
}

-(void)setnavBackground
{
    [self.navigationController.navigationBar setBackgroundImage:[Util imageWithColor:RGB(234, 58, 60)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];// 要使用默认导航栏页面的话，需要设置为nil，否则没有导航栏下面的那根线
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setnavBackground];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];// 要使用默认导航栏页面的话，需要设置为nil，否则没有导航栏下面的那根线
    self.navigationController.navigationBar.translucent = YES;
    
}


-(void)setNavRightBt
{
    NSString *strname = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYNAME];
    _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [_cityBtn setTitle:strname forState:UIControlStateNormal];
    [_cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cityBtn setBackgroundColor:[UIColor clearColor]];
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateHighlighted];
    [_cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [_cityBtn addTarget:self action:@selector(cityBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}


- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadFirstData {
    
    self.page = 1;
    [self getdata];
}

- (void)loadMoreData
{
    self.page += 1;
    [self getdata];
}

- (void)getdata {
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:_strid forKey:@"channelid"];
    [dicpush setObject:strcityid forKey:@"cityid"];
    [dicpush setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dicpush setObject:@"20" forKey:@"row"];
    
    [datacontrol homeLanMuItemListData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1 || self->_dataArray == nil)
        {
            self->_dataArray = [[NSMutableArray alloc] init];
        }
        
        if(state)
        {
            if(self->datacontrol.arrLanMuItemList.count == 0)
            {
                [self endFooterRefreshingWithNoMoreData];
            }
            for(NSDictionary *dic in self->datacontrol.arrLanMuItemList)
           {
               BanKuaiModel *model = [BanKuaiModel dicToModelValue:dic];
               [self->_dataArray addObject:model];
           }
        }
        [self.tableView reloadData];
        
    }];
    
}

-(void)cityBtnOnTouch
{
    OpenedCityVC *vc = [[OpenedCityVC alloc] initWithNibName:@"OpenedCityVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.handler = ^(id  _Nonnull cityObj) {
        OpenedCity *_oc = cityObj;
        [self->_cityBtn setTitle:_oc.title forState:UIControlStateNormal];
        [self->_cityBtn setImage:[UIImage imageNamed:@"cityBtn"] forState:UIControlStateNormal];
        [self->_cityBtn setImage:[UIImage imageNamed:@"cityBtn"] forState:UIControlStateHighlighted];
        [self->_cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_oc.title] forKey:SELECTCITYNAME];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_oc.id] forKey:SELECTCITYID];
        
        self->strcityid = [NSString stringWithFormat:@"%@",_oc.id];
        [self loadFirstData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"HomeBanKuaiItemTableViewCell";
    HomeBanKuaiItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        cell = [[HomeBanKuaiItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
    
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
    
    BanKuaiModel *model = _dataArray[indexPath.row];
    ContentDetailVC *cvc = [[ContentDetailVC alloc] init];
    cvc.contentId = [NSNumber numberWithInt:model.did.intValue];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

/**
 *  分割线的处理
 */
- (void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
