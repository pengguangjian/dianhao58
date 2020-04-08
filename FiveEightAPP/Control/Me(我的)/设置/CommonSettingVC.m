//
//  CommonSettingVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "CommonSettingVC.h"
#import "FileService.h"
#import "MessageNoticeCell.h"
#import "JPUSHService.h"
#import "LaunangeChangeAlterView.h"

@interface CommonSettingVC () {
    NSArray *textArr;
    NSArray *classNameArr;
    
    BOOL isOpenPush;
    
}
@end

@implementation CommonSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"currency", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    textArr = @[@[NSLocalizedString(@"qingchuhuancun", nil), NSLocalizedString(@"tuisongtongzhi", nil),NSLocalizedString(@"qiehuanyuyan", nil)]];
    
    
    NSString *alias = [NSString stringWithFormat:@"%@%@",[[Util getUDID] stringByReplacingOccurrencesOfString:@"-" withString:@""],[User sharedUser].user_id];
    
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([iAlias isEqualToString:alias]) {
                isOpenPush = YES;
            } else {
                isOpenPush = NO;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        });
        
    } seq:0];
    
    
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
    return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0||indexPath.row == 2) {
        static NSString *CustomCellIdentifier = @"CommonSettingCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CustomCellIdentifier];
        }
        
        cell.textLabel.textColor = COL2;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        cell.detailTextLabel.textColor = COL2;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        cell.textLabel.text = [[textArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //清除缓存路径
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                //计算大小
                float size = [FileService folderSizeAtPath:path];
                
                if (size<0) {
                    size = 0;
                }
                if (size>10000) {
                    size = 10;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", size];
                });
            });
        }
        else if (indexPath.row == 2)
        {
            
            NSString *userSettingLanguage = [NSBundle currentLanguage];
            
            if (!([userSettingLanguage isEqualToString:@"zh-Hans"]||
                [userSettingLanguage isEqualToString:@"vi"])) {
                userSettingLanguage = @"zh-Hans";
            }
            if([userSettingLanguage isEqualToString:@"zh-Hans"])
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"中文"];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Tiếng Việt"];
            }
            
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setHeight:48];
        
        return cell;
    }
    
    static NSString *CustomCellIdentifier = @"MessageNoticeCell";
    MessageNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = (MessageNoticeCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    
    
    if (isOpenPush) {
        cell.openSwitch.on = YES;
    } else {
        cell.openSwitch.on = NO;
    }
    
    [cell.openSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    cell.textLabel.text = [[textArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = COL2;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.openSwitch.tag = 1;
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //清除缓存路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        //计算大小
        float size = [FileService folderSizeAtPath:path];
        //弹出一个alterView
        [self showAlterViewWithCacheSize:size andPath:path];
        
    }
    else if (indexPath.row == 2)
    {///语言切换
        LaunangeChangeAlterView *selectSexView = [LaunangeChangeAlterView sharedView];
        [selectSexView show];
        
        selectSexView.selectLaunangeHandler = ^(int sendertag) {
            [self changeLange:sendertag];
        };
    }
    
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


/**
 *  清除缓存对话框
 *
 *  @param cacheSize 缓存大小
 *  @param path      清除缓存路径
 */
- (void)showAlterViewWithCacheSize:(float)cacheSize andPath:(NSString *)path {
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"niquedingyaschcm", nil)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"queding", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //清除缓存
        [FileService clearCache:path];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        
        if ([User sharedUser].user_id && [User sharedUser].user_id.length>0) {
            [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",[[Util getUDID] stringByReplacingOccurrencesOfString:@"-" withString:@""],[User sharedUser].user_id] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"");
            } seq:0];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenPush"];
        return;
    }
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"删除推送别名");
    } seq:0];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenPush"];
    
    //    if (switchButton.tag == 1) {
    //        if (isButtonOn) {
    //            // 关闭免打扰模式，设置后，您将收到环信推送
    //            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //            options.noDisturbStatus = EMPushNoDisturbStatusClose;
    //            EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
    //        }else {
    //            // 设置全天免打扰，设置后，您将收不到环信推送
    //            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //            //            options.noDisturbStatus = EMPushNoDisturbStatusDay;
    //            options.noDisturbStatus = EMPushNoDisturbStatusCustom;
    //            options.noDisturbingStartH = 0;
    //            options.noDisturbingEndH = 24;
    //            EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
    //        }
    //    }
    
    //    if (isButtonOn) {
    //        [self updateUserNoticeSetting:switchButton.tag withState:1];
    //    }else {
    //        [self updateUserNoticeSetting:switchButton.tag withState:2];
    //    }
}

-(void)changeLange:(int)tag
{
    
     switch (tag) {
         case 1:
             [UWConfig setUserLanguage:@"vi"];
             
             break;
         case 2:
             [UWConfig setUserLanguage:@"zh-Hans"];
             break;
         case 3:
             [UWConfig setUserLanguage:@"en"];
             break;
             
         default:
             break;
     }
     
     //更新UI
//     UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
     
//     NSUInteger tabbarSelectedIndex = tabBar.selectedIndex;
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
     //解决奇怪的动画bug。异步执行
     dispatch_async(dispatch_get_main_queue(), ^{
         [[UIApplication sharedApplication].keyWindow.layer addAnimation:[self exitAnim] forKey:nil];
         
         [app createRootVC];
         
         UITabBarController *newTabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
         newTabBar.selectedIndex = 0;
//         [Util LoginVC:YES];
         
     });
     
}

- (CAAnimation*)exitAnim {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3f];
    animation.type = @"fade";
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}


@end

