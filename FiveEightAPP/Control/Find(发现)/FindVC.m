//
//  FindVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "FindVC.h"
#import "FindListCell.h"
#import "WebViewVC.h"

#import "FindDataControler.h"

#import "FindModel.h"

@interface FindVC ()
{
    FindDataControler *datacontrol;
    NSMutableArray *arrdata;
    
}
@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self setNavigationBarTitle:NSLocalizedString(@"Find", nil) leftImage:nil andRightImage:nil];
     
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight-tabBarHeight)];
    self.tableView.isShowWithoutDataView = YES;
//    self.tableView.mj_header = nil;
        //        self.tableView.mj_footer = nil;
            //    self.tableView.isShowWithoutDataView = YES;
            //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
            
    //    self.tableView.separatorStyle = NO;
    self.tableView.separatorColor = SEPARATORCOLOR;
            
    self.tableView.tag = 10000;
        
    [self.tableView reloadData];
    datacontrol = [FindDataControler new];
    [self getdata];
    
}

-(void)getdata
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [datacontrol findListData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1 || self->arrdata==nil)
        {
            self->arrdata = [NSMutableArray new];
        }
        
        if(state)
        {
            
            for(NSDictionary *dic in self->datacontrol.arrList)
            {
                FindModel *model = [FindModel dicModelValue:dic];
                [self->arrdata addObject:model];
            }
            if(self->datacontrol.arrList.count == 0)
            {
                [self endFooterRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    }];
}

-(void)loadFirstData {
    self.page = 1;
    [self getdata];
}

-(void)loadMoreData {
    self.page += 1;
    [self getdata];
}



#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"FindListCell";
    FindListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = (FindListCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    FindModel *model = arrdata[indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.updatetime;;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = tableView.backgroundColor;
    //    cell.bgView.backgroundColor = tableView.backgroundColor;
    
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
    FindModel *model = arrdata[indexPath.row];
    WebViewVC *vc = [[WebViewVC alloc] initWithTitle:model.title andUrl:model.url];
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
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}

@end
