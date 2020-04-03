//
//  RegionalPartnersVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/24.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "RegionalPartnersVC.h"
#import "DescAndTextFieldCell.h"
#import "RegionalDataControl.h"

#import "OpenedCityVC.h"

#import "OpenedCity.h"

@interface RegionalPartnersVC ()
{
    RegionalDataControl *datacontrol;
    
    NSArray *textArr;
    NSArray *placeholderArr;
}
@end

@implementation RegionalPartnersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigationBarTitle:NSLocalizedString(@"shenfqingalovnhehuoren", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.isShowWithoutDataView = YES;
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    textArr = @[NSLocalizedString(@"applicationType", nil),NSLocalizedString(@"applicationArea", nil), NSLocalizedString(@"contacts", nil), NSLocalizedString(@"contactNumber", nil), @"E-mail"];
    placeholderArr = @[@"",NSLocalizedString(@"pleaseSelectRegion", nil), NSLocalizedString(@"pleaseWriteName", nil), NSLocalizedString(@"pleaseMobile", nil), NSLocalizedString(@"pleaseWriteEmail", nil)];
    
}

-(void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"DescAndTextFieldCell";
    DescAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CustomCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = (DescAndTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    [cell.valueTextField setUserInteractionEnabled:YES];
    if(indexPath.row == 1)
    {
        [cell.valueTextField setUserInteractionEnabled:NO];
        
        UIImageView *imgvs = [[UIImageView alloc] init];
        [imgvs setImage:[UIImage imageNamed:@"sanjiao_down_graw"]];
        [cell.contentView addSubview:imgvs];
        [imgvs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-20);
            make.centerY.equalTo(cell.contentView);
            make.size.sizeOffset(CGSizeMake(15, 15));
        }];
        
        UIButton *btselect = [[UIButton alloc] init];
        [btselect setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:btselect];
        [btselect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.valueTextField);
        }];
        [btselect addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    
    cell.descLabel.text = [textArr objectAtIndex:indexPath.row];
    cell.valueTextField.placeholder = [placeholderArr objectAtIndex:indexPath.row];
    cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
    cell.valueTextField.delegate = nil;
    
    if (indexPath.row == 0) {
        cell.valueTextField.enabled = NO;
        cell.valueTextField.text = NSLocalizedString(@"regionalPartner", nil);
    } else {
        cell.valueTextField.enabled = YES;
    }
    if (indexPath.row == 3)
    {
        [cell.valueTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (indexPath.row == 4)
    {
        [cell.valueTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 80)];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(16, 30, DEVICE_Width-32, 50)];
    [saveBtn addTarget:self action:@selector(saveBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:NSLocalizedString(@"applyingPartner", nil) forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:RGB(234, 58, 60)];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:5.0f];
    saveBtn.xsz_acceptEventInterval = 1;
//    [saveBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [footView addSubview:saveBtn];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 7)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 7)];
    }
}

#pragma mark - 地区选择
-(void)addressAction
{
    OpenedCityVC *vc = [[OpenedCityVC alloc] initWithNibName:@"OpenedCityVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.handler = ^(id  _Nonnull cityObj) {
        OpenedCity *_oc = cityObj;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        DescAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.valueTextField.text = _oc.title;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 申请
- (void)saveBtnOnTouch:(id)sender {
    
    [self.view endEditing:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    DescAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.valueTextField.text;
    
    if (!name || !(name.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseWriteName", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *phone = cell.valueTextField.text;
    
    if (phone.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"qingshuruzqshoujh", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *email = cell.valueTextField.text;
    
    if (email.length<5)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseWriteEmail", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *area = cell.valueTextField.text;
    
    if ([area stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseSelectRegion", nil)];
        return;
    }
    if(datacontrol==nil)
    {
        datacontrol = [RegionalDataControl new];
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [dicpush setObject:area forKey:@"area"];
    [dicpush setObject:name forKey:@"contact"];
    [dicpush setObject:phone forKey:@"mobile"];
    [dicpush setObject:email forKey:@"email"];
    
    
    [datacontrol regionalData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            [self leftBtnOnTouch:nil];
        }else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
    
//    HttpManager *hm = [HttpManager createHttpManager];
//
//    hm.responseHandler = ^(id responseObject) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
//
//            if ([rd.code isEqualToString:SUCCESS]) {
//
//                [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
//                [self leftBtnOnTouch:nil];
//
//            } else {
//                [SVProgressHUD showErrorWithStatus:rd.msg];
//            }
//        });
//
//    };
//
//    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
////    if (self.textField.text) {
////        [dataDic setValue:self.textField.text forKey:@"nickname"];
////    }
//    [dataDic setObject:@"zh-cn" forKey:@"lang"];
//    [dataDic setObject:[User sharedUser].user_id forKey:@"userid"];
//    [dataDic setObject:[Util getIPAddress:YES] forKey:@"ip"];
////    [dataDic setObject:[User sharedUser].token forKey:@"cityid"];
////    [dataDic setObject:[User sharedUser].token forKey:@"contact"];
////    [dataDic setObject:[User sharedUser].token forKey:@"mobile"];
////    [dataDic setObject:[User sharedUser].token forKey:@"team"];
////    [dataDic setObject:[User sharedUser].token forKey:@"type"];
//
//    [hm postRequetInterfaceData:dataDic withInterfaceName:@"api/frontend.business/apply"];
}

- (void)showToast {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"submitSuccess", nil)];
}

@end
