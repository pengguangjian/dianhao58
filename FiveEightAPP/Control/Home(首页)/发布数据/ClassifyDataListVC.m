//
//  ClassifyDataListVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/16.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "ClassifyDataListVC.h"
#import "ClassifyDataListCell.h"
#import "ContentDetailVC.h"
#import "SelectCityAreaVC.h"
#import "CityArea.h"
#import "PublishDataListObj.h"

static CGFloat const kButtonHeight = 30;
static CGFloat const kButtonWidth = 80;
static CGFloat const kRowSpacing = 16;//标签行间距

@interface ClassifyDataListVC ()
{
    NSMutableArray *keywordArr;
    NSMutableArray *keywordBtnArr;
    
    NSArray *publishListArr;
    
    UIButton *cityBtn;
    CityArea *ca;
    ColumnTypeObj *subCto;
    
    UILabel *titleLabel;
}
@end

@implementation ClassifyDataListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mPageName = @"分类列表";
    
    [self setNavigationBarTitle:nil leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    [self setNavItem];

    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    //    self.tableView.mj_header = nil;
    //    self.tableView.mj_footer = nil;
//    self.tableView.isShowWithoutDataView = YES;
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    ca = [[CityArea alloc] init];
    ca.name = @"全部";
    ca.id = [NSNumber numberWithInt:0];
    
    [self getSubColumnType];
}

- (void)setNavItem {
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 73, 24)];
    titleImageView.image = [UIImage imageNamed:@"tabbar_add_yellow"];
    self.navigationItem.titleView = titleImageView;
    
}

-(void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createHeaderView {
    
    subCto = [keywordArr firstObject];
    [self getPublishDataList];
    
    keywordBtnArr = [[NSMutableArray alloc] init];
    
    NSUInteger row = keywordArr.count/4;
    if (keywordArr.count%4>0) {
        row ++;
    }
    
    float  headViewHeight = 50+50+row*kButtonHeight+(row-1)*kRowSpacing+24+DEFAULTSECTIONALIGNHEIGHT;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, headViewHeight)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, headViewHeight-DEFAULTSECTIONALIGNHEIGHT)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:bgView];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 50)];
    [searchView setBackgroundColor:ORANGEREDCOLOR];
    [bgView addSubview:searchView];
    
    
    UIImageView *flogImageView = [[UIImageView alloc] init];
    flogImageView.image = [UIImage imageNamed:@"1"];
    [flogImageView.layer setCornerRadius:3.0f];
    [searchView addSubview:flogImageView];
    [flogImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView).with.offset(12);
        make.centerY.mas_equalTo(searchView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIButton *meBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_Width-40-8, 5, 40, 40)];
    [meBtn setTitle:@"我的" forState:UIControlStateNormal];
    [meBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [meBtn setBackgroundColor:[UIColor clearColor]];
    meBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [meBtn addTarget:self action:@selector(meBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:meBtn];
    
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(meBtn.frame.origin.x-61, 5, 60, 40)];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:[UIColor clearColor]];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [publishBtn addTarget:self action:@selector(publishBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setImage:[UIImage imageNamed:@"ic_order_n"] forState:UIControlStateNormal];
    //    cityBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [publishBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [searchView addSubview:publishBtn];
    
    UIView *cityAndSearchView = [[UIView alloc] initWithFrame:CGRectMake(60, 5, publishBtn.frame.origin.x-5-60, 40)];
    [cityAndSearchView.layer setCornerRadius:3.0f];
    [cityAndSearchView setBackgroundColor:RGBA(255, 255, 255, 0.6)];
    [searchView addSubview:cityAndSearchView];
    
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 60, 40)];
    [cityBtn setTitle:ca.name forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setBackgroundColor:[UIColor clearColor]];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateHighlighted];
    //    cityBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [cityBtn addTarget:self action:@selector(cityBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cityAndSearchView addSubview:cityBtn];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(60+18, 0, 100, 40)];
    [searchBtn setTitle:@"当地华人服务" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setImage:[UIImage imageNamed:@"searchBar_icon"] forState:UIControlStateNormal];
    [searchBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [searchBtn addTarget:self action:@selector(searchBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cityAndSearchView addSubview:searchBtn];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, DEVICE_Width, 50)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:titleView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DEVICE_Width, 1)];
    lineView.backgroundColor = SEPARATORCOLOR;
    [titleView addSubview:lineView];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 14.5, DEVICE_Width, 20)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = COL1;
    titleLabel.text = [NSString stringWithFormat:@"首页 > %@ > %@",_cto.name,subCto.name];
    [titleView addSubview:titleLabel];
    
    
    //分类按钮
    CGFloat btnHeight = kButtonHeight;//标签高度
    CGFloat btnWidth = kButtonWidth;//标签宽度
    CGFloat rowSpacing = kRowSpacing;//标签间行间距
    CGFloat columnSpacing = (DEVICE_Width-32-btnWidth*4)/3.0f;//标签间列间距
    
    int i = 0;
    for (ColumnTypeObj *cto in keywordArr) {
//    for (NSString *key in keywordArr) {
        UIButton *keywordBtn = [UIButton new];
        //属性设置
        [keywordBtn setTitle:cto.name forState:UIControlStateNormal];
//        [keywordBtn setTitle:key forState:UIControlStateNormal];
        [keywordBtn setTitleColor:COL2 forState:UIControlStateNormal];
        [keywordBtn setBackgroundColor:VIEWBGCOLOR];
        keywordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        keywordBtn.layer.cornerRadius = btnHeight/2.0f;
        keywordBtn.layer.masksToBounds = YES;
//        keywordBtn.layer.borderWidth = 0.5f;
//        keywordBtn.layer.borderColor = [DEFAULTCOLOR2 CGColor];
        [headView addSubview:keywordBtn];
        
        if (i == 0) {
            [keywordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [keywordBtn setBackgroundColor:ORANGEREDCOLOR];
        }
        
        [keywordBtnArr addObject:keywordBtn];
        
        //手势处理
        keywordBtn.tag = i;
        [keywordBtn addTarget:self action:@selector(keyWorkBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        float x = 16+i%4*(btnWidth+columnSpacing);
        float y = 100+12+i/4*(btnHeight+rowSpacing);
       
        keywordBtn.frame = CGRectMake(x, y, btnWidth, btnHeight);
        
        i++;
    }
    
    
    [self.tableView setTableHeaderView:headView];
    
}

- (void)keyWorkBtnOnTouch:(UIButton*)keywordBtn {
    
    subCto = [keywordArr objectAtIndex:keywordBtn.tag];
    [self getPublishDataList];
    
    titleLabel.text = [NSString stringWithFormat:@"首页 > %@ > %@",_cto.name,subCto.name];
    
//    if (commentType != keywordBtn.tag) {
//        commentType = keywordBtn.tag; 
//        [self loadFirstData];
//    }
    
    [keywordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [keywordBtn setBackgroundColor:ORANGEREDCOLOR];
    
    for (UIButton *btn in keywordBtnArr) {
        if (keywordBtn.tag != btn.tag) {
            [btn setTitleColor:COL2 forState:UIControlStateNormal];
            [btn setBackgroundColor:VIEWBGCOLOR];
        }
    }
    
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return publishListArr.count;
//    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"ClassifyDataListCell";
    ClassifyDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = (ClassifyDataListCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    
    PublishDataListObj *pdlo = [publishListArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@:%@",subCto.name,pdlo.title];
    cell.timeLabel.text = [NSString stringWithFormat:@"「%@」%@ 胡志明",subCto.name, [Util time_timestampToString:[pdlo.createtime doubleValue]*1000]];
    cell.commentNumLabel.text = [NSString stringWithFormat:@"%d评论",[pdlo.views intValue]];
    
    NSArray *components = [cell.titleLabel.text componentsSeparatedByString:@":"];
    NSString *classifyStr = [components firstObject];
    NSMutableAttributedString *titleLabelAttrStr = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
    [titleLabelAttrStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:15.0f]
                       range:NSMakeRange(0, classifyStr.length)];
    [titleLabelAttrStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(0, classifyStr.length)];
    cell.titleLabel.attributedText = titleLabelAttrStr;
    
    NSMutableAttributedString *timeLabelAttrStr = [[NSMutableAttributedString alloc] initWithString:cell.timeLabel.text];
    [timeLabelAttrStr addAttribute:NSForegroundColorAttributeName
                              value:PINKCOLOR
                              range:NSMakeRange(0, 1)];
    [timeLabelAttrStr addAttribute:NSForegroundColorAttributeName
                             value:ORANGEREDCOLOR
                             range:NSMakeRange(1, subCto.name.length)];
    [timeLabelAttrStr addAttribute:NSForegroundColorAttributeName
                             value:PINKCOLOR
                             range:NSMakeRange(subCto.name.length+1, 1)];
    cell.timeLabel.attributedText = timeLabelAttrStr;
    
    
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
    
    PublishDataListObj *pdlo = [publishListArr objectAtIndex:indexPath.row];
    
    ContentDetailVC *vc = [[ContentDetailVC alloc] initWithNibName:@"ContentDetailVC" bundle:nil];
    vc.contentId = pdlo.id;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---

- (void)cityBtnOnTouch:(id)sender {
    SelectCityAreaVC *vc = [[SelectCityAreaVC alloc] initWithNibName:@"SelectCityAreaVC" bundle:nil];
    vc.oc = _oc;
    vc.handler = ^(id  _Nonnull cityAreaObj) {
        ca = cityAreaObj;
        [cityBtn setTitle:ca.name forState:UIControlStateNormal];
        [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateNormal];
        [cityBtn setImage:[UIImage imageNamed:@"nav_position_open_black"] forState:UIControlStateHighlighted];
        //    cityBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [cityBtn layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleRight imageTitleSpace:3];
        
        [self getPublishDataList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --

- (void)getSubColumnType {
    
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] ) {
                
//                NSArray *dic = [rd.data valueForKey:@"list"];
                keywordArr = [ColumnTypeObj mj_objectArrayWithKeyValuesArray:rd.data];
                
                [self createHeaderView];
                
                [SVProgressHUD dismiss];
                //                [self.tableView reloadData];
                
                
                
                [self endHeaderRefreshing];
                [self endFooterRefreshing];
                
                // 变为没有更多数据的状态
                [self endFooterRefreshingWithNoMoreData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.msg];
            }
        });
    };
    
    NSDictionary *dataDic = @{@"lang":@"zh-cn",
                              @"channelid":_cto.id
                              };
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"frontend.channel/sonchannel"];
    
}

- (void)getPublishDataList {
    
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] ) {
                
                NSArray *dic = [rd.data valueForKey:@"data"];
                publishListArr = [PublishDataListObj mj_objectArrayWithKeyValuesArray:dic];
                
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
                
                [self endHeaderRefreshing];
                [self endFooterRefreshing];
                
                // 变为没有更多数据的状态
                [self endFooterRefreshingWithNoMoreData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.msg];
            }
        });
    };
    
    NSDictionary *dataDic = @{@"lang":@"zh-cn",
                              @"channelid":subCto.id
//                              ,
//                              @"cityid":_oc.id,
//                              @"areaid":ca.id
                              };
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"frontend.channel/posts"];
    
}

@end
