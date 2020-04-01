//
//  PersonalInfoVC.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "YDImagePicker.h"
#import "YDDatePickerView.h"
#import "YDSelectSexView.h"
#import "ModifyNickNameVC.h"

#import "ThirdPlatformLogin.h"

#import "PersonalInfoDataControl.h"

//#import "VerityOldPhoneVC.h"

@interface PersonalInfoVC ()<YDDatePickerViewDelegate>
{
    NSDate *selectedDate;
    
    NSArray *textArr;
    NSArray *imageNameArr;
    NSArray *classNameArr;
    
    SSDKUser *ssdkUser;
    
    PersonalInfoDataControl *datacontrol;
}

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"zhanghuygerenxinxi", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    
    
    textArr = @[@[NSLocalizedString(@"headImage", nil), NSLocalizedString(@"nickName", nil), NSLocalizedString(@"shengri", nil), NSLocalizedString(@"xingbie", nil)], @[NSLocalizedString(@"phone", nil), @"Apple ID", @"", @""]];///, @"生日", @"性别"
    imageNameArr = @[@"me_set_icon_cell", @"me_set_icon_wechat", @"me_set_icon_qq", @"me_set_icon_weibo"];
    classNameArr = @[@[@"", @"", @"", @""], @[@"", @"", @"", @""]];
    
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    datacontrol = [PersonalInfoDataControl new];
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
    
    if (section == 1) {
        return 2;
    }
    
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.textColor = COL1;
    cell.detailTextLabel.textColor = COL2;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView  *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_Width-36-10, (48-36)/2.0, 36, 36)];
        headImageView.tag = 100;
        
        NSString *headImage = [User sharedUser].headImage;
        if(![headImage hasPrefix:@"http://"] && ![headImage hasPrefix:@"https://"]) {
            headImage = [NSString stringWithFormat:@"%@%@",IMAGEPREFIX,headImage];
        }
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
        [headImageView.layer setMasksToBounds:YES];
        [headImageView.layer setCornerRadius:18.0];
        [cell addSubview:headImageView];
    }
    
    cell.textLabel.text = [[textArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 1) {
        NSString *imageName = [imageNameArr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = [Util getConcealPhoneNumber:[User sharedUser].phone];
                break;
            case 1:
            {
                NSString *appleUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appleUserID"];
                if (appleUserID.length>0) {
                    cell.detailTextLabel.text = NSLocalizedString(@"bound", nil);
                } else {
                    cell.detailTextLabel.text = NSLocalizedString(@"unbound", nil);
                }
            }
                break;
            case 2:
//                if ([[User sharedUser].isBindQQ boolValue]) {
//                    cell.detailTextLabel.text = @"已绑定";
//                } else {
//                    cell.detailTextLabel.text = @"未绑定";
//                }
                break;
            case 3:
//                if ([[User sharedUser].isBindWB boolValue]) {
//                    cell.detailTextLabel.text = @"已绑定";
//                } else {
//                    cell.detailTextLabel.text = @"未绑定";
//                }
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                cell.detailTextLabel.text = [User sharedUser].nickname;
                break;
            case 2:
                cell.detailTextLabel.text = [User sharedUser].brithday?[User sharedUser].brithday:NSLocalizedString(@"weishezhi", nil);
                break;
            case 3:
                
                if ([[User sharedUser].sex intValue] == 1) {
                    cell.detailTextLabel.text = NSLocalizedString(@"nan", nil);
                } else if ([[User sharedUser].sex intValue] == 2) {
                    cell.detailTextLabel.text = NSLocalizedString(@"nv", nil);
                } else if ([[User sharedUser].sex intValue] == 3) {
                    cell.detailTextLabel.text = NSLocalizedString(@"baomi", nil);
                }else{
                    cell.detailTextLabel.text = NSLocalizedString(@"weishezhi", nil);
                }
                
                
                break;
                
            default:
                break;
        }
    }
    
    
    
    [cell setHeight:48];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && (indexPath.row ==4 || indexPath.row == 5)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //修改选中cell背景颜色和字体颜色
    //    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    //    cell.selectedBackgroundView.backgroundColor = COL6;
    //    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    //    cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 32;
    } else {
        return 0.000001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 1) {
        return nil;
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 32)];
    [headView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, DEVICE_Width-32, 32)];
    sectionTitleLabel.font = [UIFont systemFontOfSize:12];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    sectionTitleLabel.textColor = COL3;
    sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
    sectionTitleLabel.text = NSLocalizedString(@"accountBinding", nil);
    [headView addSubview:sectionTitleLabel];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                //修改头像
                [YDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
                    if (image) {
                        
                        [self sendImage:image];
                        
                    }
                }];
                
                break;
            }
            case 1: {
                //修改昵称
                ModifyNickNameVC *vc = [[ModifyNickNameVC alloc] initWithNibName:@"ModifyNickNameVC" bundle:nil];
                vc.nickName = [User sharedUser].nickname;
                vc.isRegister = NO;
                vc.modifyHandler = ^(NSString *nickname) {
                    
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    [dataDic setValue:nickname forKey:@"nickname"];
                    [dataDic setObject:[User sharedUser].token forKey:@"token"];
                    [self saveUserInfo:dataDic];
                    
                    [User sharedUser].nickname = nickname;
                    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
                    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UITableViewCell *cell =  [self.tableView cellForRowAtIndexPath:indexPath];
                        cell.detailTextLabel.text = nickname;
                        
                    });
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 2: {
                //出生年月
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
                [dateFormatter setTimeZone:destinationTimeZone];
                NSDate *brithday = [dateFormatter dateFromString:[User sharedUser].brithday];
                
                YDDatePickerView *datePicker = [[YDDatePickerView alloc] initWithDate:brithday];
                datePicker.delegate = self;
                [datePicker show];
                break;
            }
            case 3: {
                YDSelectSexView *selectSexView = [YDSelectSexView sharedView];
                //                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                //                [window addSubview:selectSexView];
                [selectSexView show];
                
                selectSexView.selectSexHandler = ^(int sex){
                    
                [self updateSex:sex];
                };
                break;
            }
                
            default:
                break;
        }
    }
    
    
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
//                [self changeBindPhone];
                break;
            case 1:
//                if (![[User sharedUser].isBindWX boolValue]) {
//                    [self weixinLoginBtnOnTouch];
//                } else {
//                    [self unBind:[NSNumber numberWithInt:2]];
//                }
                break;
            case 2:
//                if (![[User sharedUser].isBindQQ boolValue]) {
//                    [self qqLoginBtnOnTouch];
//                } else {
//                    [self unBind:[NSNumber numberWithInt:1]];
//                }
                break;
            case 3:
//                if (![[User sharedUser].isBindWB boolValue]) {
//                    [self weiboLoginBtnOnTouch];
//                } else {
//                    [self unBind:[NSNumber numberWithInt:3]];
//                }
                break;
                
            default:
                break;
        }
    }
    
    NSString *className = [[classNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    Class someClass = NSClassFromString(className);
    UIViewController *vc = [[someClass alloc] initWithNibName:className bundle:nil];
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
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}





#pragma mark - YDDatePickerViewDelegate

- (void)selectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
   [dataDic setValue:dateStr forKey:@"birth"];
   [dataDic setObject:[User sharedUser].token forKey:@"token"];
    
    [self saveUserInfo:dataDic];
    
    [User sharedUser].brithday = dateStr;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    });
    
}


- (void)sendImage:(UIImage*)headImage {
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [datacontrol pushImageData:dicpush andimage:headImage andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       if(state)
       {
           NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
           [dataDic setObject:desc forKey:@"avatar"];
           [dataDic setObject:[User sharedUser].token forKey:@"token"];
           [self saveUserInfo:dataDic];
           
           ///存储更新头像
           [User sharedUser].headImage = desc;
           NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
           [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               
               [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"shangchuanchenggong", nil)];
               
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
               [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
           });
           
       }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pushCancle", nil)];
            
        }
        
    }];
}
- (void)updateSex:(int)sex {
    
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[NSNumber numberWithInt:sex] forKey:@"gender"];
    [dataDic setObject:[User sharedUser].token forKey:@"token"];
    [self saveUserInfo:dataDic];
    
    [User sharedUser].sex = [NSNumber numberWithInt:sex];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}

-(void)saveUserInfo:(NSMutableDictionary *)dic
{
    [datacontrol changeUserInfoData:dic andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(!state)
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
        
    }];
    
}

- (void)weixinLoginBtnOnTouch {
    
    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {
        
        NSLog(@"uid=%@",user.uid);
        NSLog(@"%@",user.credential);
        NSLog(@"token=%@",user.credential.token);
        NSLog(@"nickname=%@",user.nickname);
        
        NSMutableDictionary *rowData = [user.rawData mutableCopy];
        NSString *unionid = [rowData objectForKey:@"unionid"];
        
        NSString *openid = [rowData objectForKey:@"openid"];
        
        user.credential.token = openid;
        
        ssdkUser = user;
        
        
        [self bindThirdLogin:[NSNumber numberWithInteger:2] withBindCode:unionid];
        
    };
    [tpl loginWechat];
    
}

- (void)qqLoginBtnOnTouch {
    
    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {
        
        NSLog(@"uid=%@",user.uid);
        NSLog(@"%@",user.credential);
        NSLog(@"token=%@",user.credential.token);
        NSLog(@"nickname=%@",user.nickname);
        
        
        [self bindThirdLogin:[NSNumber numberWithInteger:1] withBindCode:user.uid];
        
    };
    [tpl loginQQ];
}

- (void)weiboLoginBtnOnTouch {
    
    
    ThirdPlatformLogin *tpl = [ThirdPlatformLogin sharedThirdPlatformLogin];
    tpl.thirdPlatformLoginHandler = ^(SSDKUser *user) {
        
        NSLog(@"uid=%@",user.uid);
        NSLog(@"%@",user.credential);
        NSLog(@"token=%@",user.credential.token);
        NSLog(@"nickname=%@",user.nickname);
        
        [self bindThirdLogin:[NSNumber numberWithInteger:3] withBindCode:user.uid];
        
    };
    [tpl loginSina];
    
}

- (void)bindThirdLogin:(NSNumber*)type withBindCode:(NSString*)bindCode {
    
    /*
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS]) {
                
                int row = 0;
                switch ([type intValue]) {
                    case 1:
                        row = 2;//QQ
                        [User sharedUser].isBindQQ = [NSNumber numberWithInt:1];
                        break;
                    case 2:
                        row = 1;//WX
                        [User sharedUser].isBindWX = [NSNumber numberWithInt:1];
                        break;
                    case 3:
                        row = 3;//WB
                        [User sharedUser].isBindWB = [NSNumber numberWithInt:1];
                        break;
                        
                    default:
                        break;
                }
                
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
                [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.msg];
            }
        });
        
    };
    
    NSMutableDictionary *dataDic = [@{@"type": type,
                                      @"bindcode":bindCode
                                      } mutableCopy];
    if (ssdkUser) {
        [dataDic setValue:ssdkUser.credential.token forKey:@"ticket"];
    }
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"user/bind"];
    
    */
}

- (void)unBind:(NSNumber*)type {
    
    
//    HttpManager *hm = [HttpManager createHttpManager];
//    hm.responseHandler = ^(id responseObject) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
//
//            if ([rd.code isEqualToString:SUCCESS]) {
//
//                [SVProgressHUD showSuccessWithStatus:@"成功解绑"];
//
//                int row = 0;
//                switch ([type intValue]) {
//                    case 1:
//                        row = 2;//QQ
//                        [User sharedUser].isBindQQ = [NSNumber numberWithInt:0];
//                        break;
//                    case 2:
//                        row = 1;//WX
//                        [User sharedUser].isBindWX = [NSNumber numberWithInt:0];
//                        break;
//                    case 3:
//                        row = 3;//WB
//                        [User sharedUser].isBindWB = [NSNumber numberWithInt:0];
//                        break;
//
//                    default:
//                        break;
//                }
//
//
//                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[User sharedUser]];
//                [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//
//
//            } else {
//                [SVProgressHUD showErrorWithStatus:rd.msg];
//            }
//        });
//
//    };
//
//    NSDictionary *dataDic = @{@"type": type
//                              };
//    [hm getRequetInterfaceData:dataDic withInterfaceName:@"user/unbind"];
    
    
}

//- (void)changeBindPhone {
//    VerityOldPhoneVC *vc = [[VerityOldPhoneVC alloc] initWithNibName:@"VerityOldPhoneVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//}



@end
