//
//  WalletVC.m
//  TechnicianAPP
//
//  Created by Mac on 2018/7/17.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "WalletVC.h"
#import "AvailableBalanceCell.h"
#import "WalletListCell.h"
//#import "BankCardListVC.h"
//#import "OutMoneyVC.h"
#import "ScoreListObj.h"
#import "YDPayPwdView.h"
#import "YDDatePickerView.h"
#import "QFDatePickerView.h"
#import "TransactionDetailVC.h"
#import "OrderVC.h"

@interface WalletVC ()
{
    NSMutableArray *dataArray;
    NSMutableArray *sectionArr;
    NSUInteger year;
    NSUInteger month;
    
    NSString *dateStr;
    
    float money;
}
@end

@implementation WalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBarTitle:@"我的米袋" leftImage:[UIImage imageNamed:@"ic_stat_back_02_s"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
//    self.tableView.mj_footer = nil;
//    self.tableView.isShowWithoutDataView = YES;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
//    [self createTableViewHeadView];
    
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    year = [components year];
    month = [components month];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    dateStr = [formatter stringFromDate:[NSDate date]];
    
    [self walletData];
    [self loadFirstData];
    
//    [self setNavItem];
}

- (void)setNavItem {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"银行卡" forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        CGFloat offset = 8;
        rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
        rightBtn.translatesAutoresizingMaskIntoConstraints = false;
    }
    [rightBtn setTitleColor:COL1 forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(rightBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =  rightItem;
    
}

- (void)rightBtnOnTouch:(id)sender {
//    BankCardListVC *vc = [[BankCardListVC alloc] initWithNibName:@"BankCardListVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)walletData {
    
    HttpManager *hm = [HttpManager createHttpManager];
    
    hm.responseHandler = ^(id responseObject) {
        
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:SUCCESS]) {
            
            money = [[rd.data objectForKey:@"amount"] floatValue];
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:rd.sub_msg];
            });
        }
    };
    
    
    [hm getRequetInterfaceData:nil withInterfaceName:@"user/useraccount"];
    
}


- (void)loadFirstData {
    
    self.page = 1;
    dataArray = [[NSMutableArray alloc] init];
    sectionArr = [[NSMutableArray alloc] init];
    [self loadMoreData];
}

- (void)loadMoreData {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    HttpManager *hm = [HttpManager createHttpManager];
    
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] && [rd.sub_code isEqualToString:SUCCESS]) {
                
                NSArray *dic = [rd.data valueForKey:@"resultList"];
                NSArray *tempArr  = [ScoreListObj mj_objectArrayWithKeyValuesArray:dic];
                
                NSMutableArray *sectionDataArr = [dataArray lastObject];
                ScoreListObj *lastSL = nil;
                if (!sectionDataArr) {
                    sectionDataArr = [[NSMutableArray alloc] init];
                } else {
                    lastSL = [sectionDataArr lastObject];
                }
                
                if (tempArr.count>0) {
                    NSInteger index = 0;
                    for (ScoreListObj *sl in tempArr) {
                        sl.iitTime = [[dic objectAtIndex:index] objectForKey:@"initTime"];
                        
                        NSTimeInterval interval = [sl.iitTime doubleValue] / 1000.0;
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        sl.datetime = [formatter stringFromDate: date];
                        
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
                        
                        NSUInteger slYear = [components year];
                        NSUInteger slMonth = [components month];
                        
                        sl.year = [NSNumber numberWithInteger:slYear];
                        sl.month = [NSNumber numberWithInteger:slMonth];
                        
                        if (lastSL) {
                            
                            if ([lastSL.year integerValue] == slYear && [lastSL.month integerValue] == slMonth) {
                                [sectionDataArr addObject:sl];
                                [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:sectionDataArr];
                            } else {
                                sectionDataArr = [[NSMutableArray alloc] init];
                                [sectionDataArr addObject:sl];
                                [dataArray addObject:sectionDataArr];
                                
                                [sectionArr addObject:[NSString stringWithFormat:@"%zi月",slMonth]];
                            }
                            
                            lastSL = sl;
                            
                            
                        } else {
                            [sectionDataArr addObject:sl];
                            [dataArray addObject:sectionDataArr];
                            lastSL = sl;
                            if (year == slYear && month == slMonth) {
                                [sectionArr addObject:@"本月"];
                            } else {
                                [sectionArr addObject:[NSString stringWithFormat:@"%zi月",slMonth]];
                            }
                        }
                        
                        index++;
                    }
                    
                } else {
                    if (dateStr) {
                        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
                        if ([[dateArr firstObject] intValue]==year && [[dateArr objectAtIndex:1] intValue]==month ) {
                            [sectionArr addObject:@"本月"];
                        } else {
                            [sectionArr addObject:[NSString stringWithFormat:@"%d月",[[dateArr objectAtIndex:1] intValue]]];
                        }
                    } else {
                        [sectionArr addObject:@"本月"];
                    }
                }
                
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
                
                [self endHeaderRefreshing];
                [self endFooterRefreshing];
                
                if (tempArr.count < ONE_PAGE) {
                    // 变为没有更多数据的状态
                    [self endFooterRefreshingWithNoMoreData];
                }
                
                self.page++;
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.sub_msg];
            }
        });
    };
    
    NSMutableDictionary *dataDic = @{@"pageNo":[NSNumber numberWithInt:self.page],
                                     @"pageSize":[NSNumber numberWithInt:ONE_PAGE],
                                     @"date":dateStr
                                     };
    
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"user/useraccountlogs"];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
//    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:NAVCOLOR andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};

    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor whiteColor] andIsShowSplitLine:NO];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: COL1,
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};


}

-(void)leftBtnOnTouch:(id)sender
{
    if (_isBackToOrderListVC) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        //返回订单
        UITabBarController *tabBarCtrl = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        
        UINavigationController *navi = [tabBarCtrl.viewControllers objectAtIndex:2];
        OrderVC *orderVC = [navi.viewControllers firstObject];
        orderVC.segmentedControl.selectedSegmentIndex = 2;
        orderVC.selectedSegmentIndex = 2;
        [tabBarCtrl setSelectedIndex:2];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateBtnOnTouch:(id)sender {
    
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        dateStr = [NSString stringWithFormat:@"%@-01",str];
        [self loadFirstData];
    }];
    [datePickerView show];
    
//    YDDatePickerView *datePicker = [[YDDatePickerView alloc] initWithDate:[NSDate date]];
//    datePicker.delegate = self;
//    [datePicker show];
    
}

#pragma mark - YDDatePickerViewDelegate

- (void)selectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [formatter stringFromDate:date];
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
//    NSInteger month = [components month];
    
//    sectionArr = [[NSMutableArray alloc] init];
//    [sectionArr addObject:[NSString stringWithFormat:@"%zi月",month]];
//
//    self.page = 1;
//    dataArray = [[NSMutableArray alloc] init];
//    [self loadMoreData];
    
    [self loadFirstData];
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    } else {
        NSArray *arr = [dataArray objectAtIndex:section-1];
        return arr.count;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionArr.count+1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.section == 0) {
        static NSString *CustomCellIdentifier = @"AvailableBalanceCell";
        AvailableBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (!cell)
        {
            UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
            cell = (AvailableBalanceCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        }
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",money];
        [cell.outMoneyBtn addTarget:self action:@selector(outMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.outMoneyBtn.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *CustomCellIdentifier = @"WalletListCell";
        WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (!cell)
        {
            UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
            cell = (WalletListCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        }
        
        NSArray *arr = [dataArray objectAtIndex:indexPath.section-1];
        ScoreListObj *so = [arr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = so.typeStr;
        cell.dateTimeLabel.text = [Util time_timestampToString:[so.iitTime doubleValue]];
        
        
        if ([so.amount intValue]>0) {
            cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [so.amount doubleValue]];
//            cell.moneyLabel.textColor = COL1;
        } else {
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [so.amount doubleValue]];
//            cell.moneyLabel.textColor = REDCOLOR;
        }
        
        cell.containerView.hidden = YES;
        
        switch ([so.ctype intValue]) {
            case 1:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"0fd6ce");
                cell.typeLabel.text = @"系";
                break;
            case 2:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"25bbf9");
                cell.typeLabel.text = @"充";
                break;
            case 3:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"ff8315");
                cell.typeLabel.text = @"家";
                break;
            case 4:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"ffae00");
                cell.typeLabel.text = @"面";
                break;
            case 5:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"4ce9b3");
                cell.typeLabel.text = @"店";
                break;
            case 6:
                cell.typeLabel.backgroundColor = REDCOLOR;
                cell.typeLabel.text = @"退";
                break;
            case 21:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"cc79f7");
                cell.typeLabel.text = @"送";
                break;
                
            default:
                cell.typeLabel.backgroundColor = HEXCOLOR(@"ffffff");
                cell.typeLabel.text = @"";
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    } else {
        return 45;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 45)];
    [headView setBackgroundColor:[UIColor clearColor]];

    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, DEVICE_Width-132, 15)];
    sectionTitleLabel.font = [UIFont systemFontOfSize:14];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    sectionTitleLabel.textColor = COL2;
    sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
    sectionTitleLabel.text = [sectionArr objectAtIndex:section-1];
    [headView addSubview:sectionTitleLabel];
    
    if (section == 1) {
        UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dateBtn setFrame:CGRectMake(DEVICE_Width-20-16, 12.5, 20, 20)];
        UIImage *btnImage = [UIImage imageNamed:@"wallet_calendar"];
        //UIImageRenderingModeAlwaysOriginal这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
        btnImage = [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //setImage 是会渲染的
        [dateBtn setImage:btnImage forState:UIControlStateNormal];
        [dateBtn addTarget:self action:@selector(dateBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:dateBtn];
    }
    

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
        return;
    }
    
    NSArray *arr = [dataArray objectAtIndex:indexPath.section-1];
    ScoreListObj *so = [arr objectAtIndex:indexPath.row];
    
    if([so.ctype intValue] == 1) {
        return;
    };
    
    TransactionDetailVC *vc = [[TransactionDetailVC alloc] initWithNibName:@"TransactionDetailVC" bundle:nil];
    vc.slo = so;
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
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }

}

#pragma mark --
- (void)outMoneyBtn:(id)sender {
    
//    OutMoneyVC *vc = [[OutMoneyVC alloc] initWithNibName:@"OutMoneyVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
