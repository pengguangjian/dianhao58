//
//  SafeSettingVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/5/21.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "SafeSettingVC.h"
#import "LoginForgetPwdVC.h"

@interface SafeSettingVC ()
{
    
    NSArray *textArr;
    NSArray *detailTextArr;
    NSArray *classNameArr;
}

@end

@implementation SafeSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"securitySetting", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    textArr = @[NSLocalizedString(@"dengluima", nil)];
    detailTextArr =  @[@"修改", @"未设置"];
    classNameArr = @[@""];
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

- (void)leftBtnOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self.tableView reloadData];
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.textColor = COL1;
    cell.detailTextLabel.textColor = ORANGEREDCOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    cell.textLabel.text = [textArr objectAtIndex:indexPath.row] ;
//    cell.detailTextLabel.text = [detailTextArr objectAtIndex:indexPath.row] ;
    
//    if (indexPath.row == 0) {
//        if ([[User sharedUser].isSetLoginPwd boolValue]) {
//            cell.detailTextLabel.text = @"修改";
//        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"xiugai", nil);
//        }
//    } else {
//        if ([[User sharedUser].isSetPayPwd boolValue]) {
//            cell.detailTextLabel.text = @"修改";
//        } else {
//            cell.detailTextLabel.text = @"未设置";
//        }
//    }
    
    
    [cell setHeight:48];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //修改选中cell背景颜色和字体颜色
    //    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    //    cell.selectedBackgroundView.backgroundColor = COL6;
    //    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    //    cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    
    LoginForgetPwdVC *vc = [[LoginForgetPwdVC alloc] initWithNibName:@"LoginForgetPwdVC" bundle:nil];
//    vc.style = 2;
    vc.ischangePassword = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    ModifyPwdVC *vc = [[ModifyPwdVC alloc] initWithNibName:@"ModifyPwdVC" bundle:nil];
//    vc.style = LoginPwd;
//    [self.navigationController pushViewController:vc animated:YES];
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
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

@end
