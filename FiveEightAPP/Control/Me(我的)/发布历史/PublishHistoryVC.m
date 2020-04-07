//
//  PublishHistoryVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/24.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "PublishHistoryVC.h"
#import "PublishHistoryDataControl.h"
#import "HomeSearchTableViewCell.h"

#import "ContentDetailVC.h"

@interface PublishHistoryVC ()
{
    NSMutableArray *_dataArray;
    PublishHistoryDataControl *datacontrol;
}
@end

@implementation PublishHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"publicHestory", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    //    self.tableView.mj_header = nil;
    //    self.tableView.mj_footer = nil;
    self.tableView.isShowWithoutDataView = YES;
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    datacontrol = [PublishHistoryDataControl new];
    
    [self loadFirstData];
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
    [dicpush setObject:[User sharedUser].user_id forKey:@"user_id"];
    [dicpush setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dicpush setObject:@"20" forKey:@"row"];
    
    [datacontrol publishHistoryData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1 || self->_dataArray == nil)
        {
            self->_dataArray = [[NSMutableArray alloc] init];
        }
        
        if(state)
        {
            if(self->datacontrol.arrList.count == 0)
            {
                [self endFooterRefreshingWithNoMoreData];
            }
            for(NSDictionary *dic in self->datacontrol.arrList)
           {
               BanKuaiModel *model = [BanKuaiModel dicToModelValue:dic];
               [self->_dataArray addObject:model];
           }
        }
        [self.tableView reloadData];
        
    }];
    
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
    
    if([model.status isEqualToString:@"normal"])
    {
        ContentDetailVC *cvc = [[ContentDetailVC alloc] init];
        cvc.contentId = [NSNumber numberWithInt:model.did.intValue];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"shanchu", nil);
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        BanKuaiModel *model = _dataArray[indexPath.row];
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:[User sharedUser].token forKey:@"token"];
        [dicpush setObject:model.did forKey:@"key"];
        
        [datacontrol publishHistoryDeleData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
            if(state)
            {
                [self->_dataArray removeObject:model];
                [tableView reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:desc];
                
            }
        }];
        
    }
    
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


@end
