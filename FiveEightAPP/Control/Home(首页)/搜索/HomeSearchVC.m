//
//  HomeSearchVC.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeSearchVC.h"
#import "HomeBanKuaiDataControl.h"
#import "BanKuaiModel.h"
#import "ContentDetailVC.h"
#import "HomeSearchTableViewCell.h"
#import "OpenedCityVC.h"
#import "OpenedCity.h"

@interface HomeSearchVC ()
{
    UIButton *cityBtn;
    NSMutableArray *_dataArray;
    HomeBanKuaiDataControl *datacontrol;
    NSString *strcityid;
    NSString *strkeywords;
}

@property (nonatomic , retain) UITextField *fieldSearch;

@end

@implementation HomeSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    strkeywords = @"";
    [self setNavigationBarTitle:NSLocalizedString(@"sousuo", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
        
    UIView *viewtop = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, 50)];
    [viewtop setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewtop];
    [self drawtopVIew:viewtop];
    
    [self initWithRefreshTableView:CGRectMake(0, viewtop.bottom, DEVICE_Width, DEVICE_Height-viewtop.bottom)];
    
    self.tableView.isShowWithoutDataView = YES;
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    datacontrol = [HomeBanKuaiDataControl new];
    strcityid = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYID];
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)drawtopVIew:(UIView *)view
{
    [view setBackgroundColor:[UIColor redColor]];
    UIImageView *flogImageView = [[UIImageView alloc] init];
    flogImageView.image = [UIImage imageNamed:@"1"];
    [flogImageView.layer setCornerRadius:3.0f];
    [view addSubview:flogImageView];
    [flogImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(12);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setTitle:NSLocalizedString(@"sousuo", nil) forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:[UIColor clearColor]];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [publishBtn addTarget:self action:@selector(searchBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.bottom.equalTo(view);
        make.width.offset(40);
    }];
    NSString *strcityname = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTCITYNAME];
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 5, 60, 40)];
    [cityBtn setTitle:strcityname forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setBackgroundColor:[UIColor clearColor]];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateHighlighted];
    //    cityBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [cityBtn addTarget:self action:@selector(cityBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cityBtn];
    
    
    ///搜索框
    UIView *viewsearch = [[UIView alloc] init];
    [viewsearch setBackgroundColor:RGBA(255, 255, 255, 0.6)];
    [viewsearch.layer setCornerRadius:3.0f];
    [view addSubview:viewsearch];
    [viewsearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->cityBtn.mas_right);
        make.right.equalTo(publishBtn.mas_left);
        make.top.offset(5);
        make.height.offset(40);
    }];
    UIImageView *imgvsearch = [[UIImageView alloc] init];
    [imgvsearch setImage:[UIImage imageNamed:@"searchBar_icon"]];
    [viewsearch addSubview:imgvsearch];
    [imgvsearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(viewsearch);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    
    UITextField *fieldsearch = [[UITextField alloc] init];
    [fieldsearch setTextColor:[UIColor whiteColor]];
    [fieldsearch setTextAlignment:NSTextAlignmentLeft];
    [fieldsearch setFont:[UIFont systemFontOfSize:14]];
    [fieldsearch setPlaceholder:NSLocalizedString(@"zhaogongzuozhaofangz", nil)];
    [fieldsearch setBackgroundColor:[UIColor clearColor]];
    [viewsearch addSubview:fieldsearch];
    [fieldsearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvsearch.mas_right).offset(10);
        make.top.bottom.right.equalTo(viewsearch);
    }];
    _fieldSearch = fieldsearch;
    [fieldsearch becomeFirstResponder];
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
    [dicpush setObject:strkeywords forKey:@"keywords"];
    [dicpush setObject:strcityid forKey:@"cityid"];
    [dicpush setObject:@"0" forKey:@"areaid"];
    [dicpush setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dicpush setObject:@"20" forKey:@"row"];
    
    [datacontrol homesearchListData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1 || self->_dataArray == nil)
        {
            self->_dataArray = [[NSMutableArray alloc] init];
        }
        
        if(state)
        {
            if(self->datacontrol.arrhomesearchLis.count == 0)
            {
                [self endFooterRefreshingWithNoMoreData];
            }
            for(NSDictionary *dic in self->datacontrol.arrhomesearchLis)
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
        [self->cityBtn setTitle:_oc.title forState:UIControlStateNormal];
        [self->cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateNormal];
        [self->cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateHighlighted];
        [self->cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_oc.title] forKey:SELECTCITYNAME];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_oc.id] forKey:SELECTCITYID];
        
        self->strcityid = [NSString stringWithFormat:@"%@",_oc.id];
        [self loadFirstData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchBtnOnTouch
{
    [_fieldSearch resignFirstResponder];
    if(_fieldSearch.text.length<1)
    {
        return;
    }
    self.page = 1;
    strkeywords =  _fieldSearch.text;
    [self getdata];
}

#pragma mark - tableView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_fieldSearch resignFirstResponder];
}
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
    
    static NSString *CustomCellIdentifier = @"HomeSearchTableViewCell";
    HomeSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        cell = [[HomeSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
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
