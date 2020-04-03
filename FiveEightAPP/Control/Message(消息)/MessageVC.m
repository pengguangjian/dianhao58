//
//  MessageVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "MessageVC.h"

#import "NoticeTypeCell.h"

#import "MessageDataControl.h"

#import "MessageModel.h"

#import "ContentDetailVC.h"

#import "WebViewVC.h"

@interface MessageVC ()
{
    int unReadCount;
    
    MessageDataControl *datacontrol;
    
}
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self setNavigationBarTitle:NSLocalizedString(@"Message", nil) leftImage:nil andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight-tabBarHeight)];
    self.tableView.isShowWithoutDataView = YES;
    self.tableView.separatorColor = SEPARATORCOLOR;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getdata];
}

- (void)getdata {
    if(datacontrol==nil)
    {
        datacontrol = [MessageDataControl new];
    }
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    if (![User isNeedLogin])
    {
        [dicpush setObject:[User sharedUser].user_id forKey:@"user_id"];
    }
    
    [dicpush setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [datacontrol messageListData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1 || self->_dataArray==nil)
        {
            self->_dataArray = [NSMutableArray new];
        }
       if(state)
       {
           for(NSDictionary *dic in self->datacontrol.arrList)
           {
               MessageModel *model = [MessageModel dicModelValue:dic];
               [self->_dataArray addObject:model];
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

-(void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"NoticeTypeCell";
    NoticeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = (NoticeTypeCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    cell.noticeImageView.image = [UIImage imageNamed:@"system_message"];
    MessageModel *model = _dataArray[indexPath.row];
    cell.typeNameLabel.text = NSLocalizedString(@"systemMessage", nil);
    cell.dateLabel.text = model.time;
    cell.contentLabel.text = model.content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    MessageModel *model = _dataArray[indexPath.row];
    if(model.msg_type.integerValue == 1)
    {
        ContentDetailVC *cvc = [[ContentDetailVC alloc] init];
        cvc.contentId = [NSNumber numberWithInt:model.article_id.intValue];
        cvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else if(model.msg_type.integerValue == 2)
    {
        WebViewVC *view = [[WebViewVC alloc] initWithTitle:NSLocalizedString(@"systemMessage", nil) andUrl:model.url];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = _dataArray[indexPath.row];
    return model.fcellheight;
}

/**
 *  分割线的处理
 */
- (void)viewDidLayoutSubviews
{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 7)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 7)];
    }
}

@end




