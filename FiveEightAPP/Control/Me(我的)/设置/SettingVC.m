//
//  SettingVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "SettingVC.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "LoginVC.h"

#import "WebViewVC.h"

@interface SettingVC () {
    NSArray *textArr;
    NSArray *classNameArr;
}
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"setUp", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    textArr = @[@[NSLocalizedString(@"personalInformation", nil), NSLocalizedString(@"securitySetting", nil), NSLocalizedString(@"currency", nil)], @[NSLocalizedString(@"systemScore", nil), NSLocalizedString(@"使用条款", nil),NSLocalizedString(@"免责声明", nil),NSLocalizedString(@"商家协议", nil),NSLocalizedString(@"systemAbout", nil)], @[NSLocalizedString(@"loginOut", nil)]];
    classNameArr = @[@[@"PersonalInfoVC", @"SafeSettingVC", @"CommonSettingVC"], @[@"", @"AboutVC",@"AboutVC",@"AboutVC",@"AboutVC"], @[@""]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    
    
    [self.tableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: COL1,
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};

    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    
    cell.textLabel.textColor = COL2;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    cell.detailTextLabel.textColor = COL2;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    cell.textLabel.text = [[textArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //退出登录
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        
        if ([User isNeedLogin]) {
            //未登录
            cell.textLabel.textColor = COL1;
            cell.textLabel.text = NSLocalizedString(@"ImmediatelyLogin", nil);
        }
    }
    
    [cell setHeight:48];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 0.000001;
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
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0 || indexPath.row == 1)
        {
            if ([User isNeedLogin]) {
                LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                loginNC.modalPresentationStyle  = UIModalPresentationFullScreen;
                [self presentViewController:loginNC animated:YES completion:nil];
                return;
            }
        }
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
            return;
        }
        
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", @"1420965259"];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        return;
    }
    
    
    if (indexPath.section == 2) {
        [self logout];
        [Util LoginVC:YES];
        return;
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row>0)
        {
            NSArray *arrurl = @[@"",@"frontend.page/terms",@"frontend.page/disclaimer",@"frontend.page/merchant",@"frontend.page/registration"];
            NSArray *arrtemp = textArr[indexPath.section];
            WebViewVC *wvc = [[WebViewVC alloc] initWithTitle:arrtemp[indexPath.row] initWithTitle:arrurl[indexPath.row]];
            
            [self.navigationController pushViewController:wvc animated:YES];
            
            return;
        }
    }
    
    
    NSString *className = [[classNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    Class someClass = NSClassFromString(className);
    UIViewController *vc = [[someClass alloc] initWithNibName:className bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)logout {
    
    
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"删除推送别名");
    } seq:0];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenPush"];
    
    [User clearUser];
    
    [self.tableView reloadData];
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
