//
//  RealNameAuthVC.m
//  TechnicianAPP
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "RealNameAuthVC.h"
#import "DescAndTextFieldCell.h"
#import "XSZRadioButton.h"
#import "YDImagePicker.h"
#import "StoreSuthDataControl.h"
#import "WebViewVC.h"

@interface RealNameAuthVC ()
{
    NSArray *textArr;
    NSArray *placeholderArr;
    
    NSMutableArray* radioBtnArr;
    BOOL isAgreement;//是否同意协议
    
    ///身份证正反面100
    UIButton *btimagezm;
    UIButton *btimagefm;
    UIButton *btimagezy;
    NSString *strimagezm;
    NSString *strimagefm;
    NSString *strimagezy;
    
    StoreSuthDataControl *datacontrol;
    
}
@end

@implementation RealNameAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"eerchantCertification", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    textArr = @[NSLocalizedString(@"enterpriseName", nil),
                NSLocalizedString(@"enterpriseNumber", nil),
                NSLocalizedString(@"legalName", nil),
                NSLocalizedString(@"legalNumber", nil)];
    placeholderArr = @[NSLocalizedString(@"pleaseEnterpriseName", nil),
                       NSLocalizedString(@"noUnifiedCode", nil),
                       NSLocalizedString(@"pleaseLegalName", nil),
                       NSLocalizedString(@"pleaseLegalNumber", nil)];
    
    [self createFooterView];

    [self createHeaderView];
    
    datacontrol = [StoreSuthDataControl new];
    
}

- (void)createHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 35)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, DEVICE_Width-32, headView.height)];
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textColor = COL2;
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.text = NSLocalizedString(@"pleaseEnterpriseRealDataAuthentication", nil);//_aso.nameErrorStr;
    [headView addSubview:descLabel];
    
    self.tableView.tableHeaderView = headView;
    
}

-(void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createFooterView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 24+110)];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    radioBtnArr = [NSMutableArray arrayWithCapacity:1];
    XSZRadioButton *radioBtn = [[XSZRadioButton alloc] initWithFrame:CGRectMake(16, 7, 30, 30)];
    [radioBtn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    [radioBtn setTitleColor:COL2 forState:UIControlStateNormal];
    [radioBtn setTitleColor:COL2 forState:UIControlStateSelected];
    radioBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    radioBtn.tintColor = [UIColor whiteColor];
    
    UIImage *btnImage = [UIImage imageNamed:@"unchecked"];
    //UIImageRenderingModeAlwaysOriginal这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
    btnImage = [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //setImage 是会渲染的
    [radioBtn setImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"checked"];
    btnImage = [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [radioBtn setImage:btnImage forState:UIControlStateSelected];
    radioBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    radioBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [footView addSubview:radioBtn];
    
    [radioBtnArr addObject:radioBtn];
    [radioBtnArr[0] setGroupButtons:radioBtnArr]; // 设置为同一组
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+16+10, 5, DEVICE_Width-42, 35)];
    protocolLabel.text = NSLocalizedString(@"agreementConsent", nil);
    protocolLabel.numberOfLines = 0;
    protocolLabel.textColor = COL3;
    protocolLabel.font = [UIFont systemFontOfSize:14.0f];
    [footView addSubview:protocolLabel];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:protocolLabel.text];
    NSRange range = [protocolLabel.text rangeOfString:NSLocalizedString(@"renzhenxieyi", nil)];
    range.length = range.length+2;
    range.location = range.location-1;
    
    @try {
        [attrString addAttribute:NSForegroundColorAttributeName
        value:RGB(234, 58, 60)
        range:range];///中文
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    protocolLabel.attributedText = attrString;
    
    UIButton *userAgreementBtn = [[UIButton alloc]initWithFrame:CGRectMake(16+16+10, 15, DEVICE_Width-42, 14)];
    [userAgreementBtn addTarget:self action:@selector(userAgreementBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:userAgreementBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(16, 24+35, DEVICE_Width-32, 50)];
    [saveBtn addTarget:self action:@selector(saveBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:NSLocalizedString(@"confirmSubmission", nil) forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:RGB(234, 58, 60)];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:5.0f];
    saveBtn.xsz_acceptEventInterval = 1;
//    [saveBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [footView addSubview:saveBtn];
    
    self.tableView.tableFooterView = footView;
    
}

// 用户协议
- (void)userAgreementBtnOnTouch:(id)sender {
    WebViewVC *vc = [[WebViewVC alloc] initLoadRequest:NSLocalizedString(@"renzhenxieyi", nil) initWithTitle:@"frontend.page/registration"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRadioButtonValueChanged:(UIButton*)btn {
    
    if (btn.isSelected) {
        NSLog(@"选择的：%@",btn.titleLabel.text);
        isAgreement = YES;
        
    } else {
        NSLog(@"取消选择的：%@",btn.titleLabel.text);
        isAgreement = NO;
    }
}


#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
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
    
    
    cell.descLabel.text = [textArr objectAtIndex:indexPath.row];
    cell.descLabel.textAlignment = NSTextAlignmentLeft;
    cell.valueTextField.placeholder = [placeholderArr objectAtIndex:indexPath.row];
    cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
    cell.valueTextField.delegate = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 285;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 150)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btitemz = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, (DEVICE_Width-60)/2.0, 120)];
    [view addSubview:btitemz];
//    [self drawBtuuon:btitemz andimage:@"3" andtitle:NSLocalizedString(@"legalFrontIDCard", nil)];
    [self drawBtuuon:btitemz andimage:@"shenfenz_zm" andtitle:NSLocalizedString(@"frontIDCard", nil)];
    [btitemz setTag:0];
    [btitemz addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    btimagezm = btitemz;
    
    UIButton *btitemf = [[UIButton alloc] initWithFrame:CGRectMake(btitemz.right+30, btitemz.top, btitemz.width, btitemz.height)];
    [view addSubview:btitemf];
//    [self drawBtuuon:btitemf andimage:@"3" andtitle:NSLocalizedString(@"legalReverseIDCard", nil)];
    [self drawBtuuon:btitemf andimage:@"shenfenz_fm" andtitle:NSLocalizedString(@"reverseIDCard", nil)];
    [btitemf setTag:1];
    [btitemf addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    btimagefm = btitemf;
    
    UIButton *btitemzj = [[UIButton alloc] initWithFrame:CGRectMake(btitemz.left, btitemz.bottom+15, btitemz.width, btitemz.height)];
   [view addSubview:btitemzj];
//   [self drawBtuuon:btitemzj andimage:@"3" andtitle:NSLocalizedString(@"businessPhoto", nil)];
    [self drawBtuuon:btitemzj andimage:@"yingyezhizhao_rz" andtitle:NSLocalizedString(@"businessPhoto", nil)];
    [btitemzj setTag:2];
    [btitemzj addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    btimagezy = btitemzj;
    
    return view;
}

-(void)drawBtuuon:(UIButton *)bt andimage:(NSString *)strimage andtitle:(NSString *)strtitle
{
 
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setImage:[UIImage imageNamed:strimage]];
    [bt addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bt);
        make.bottom.equalTo(bt).offset(-10);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:strtitle];
    [lbtitle setTextColor:RGB(50, 50, 50)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    lbtitle.adjustsFontSizeToFitWidth = YES;
    lbtitle.minimumScaleFactor = 0.1;
    [bt addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bt);
        make.height.offset(20);
        make.centerY.equalTo(bt).offset(20);
    }];
    
    
    UIImageView *imgv1 = [[UIImageView alloc] init];
    [imgv1 setTag:100];
    [imgv1 setBackgroundColor:[UIColor clearColor]];
    [bt addSubview:imgv1];
    [imgv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bt);
        make.bottom.equalTo(bt).offset(-10);
    }];
    
    
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

#pragma mark - 身份证图片选择
-(void)imageAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    //
    [YDImagePicker showImagePickerFromViewController:self allowsEditing:NO finishAction:^(UIImage *image) {
        if (image) {
            
            [self sendImage:image andsendTag:sender.tag];
            
        }
    }];
    
}
/////tag 0 正面
- (void)sendImage:(UIImage*)headImage andsendTag:(NSInteger)tag{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [datacontrol pushImageData:dicpush andimage:headImage andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       if(state)
       {
           if(tag==0)
           {
               self->strimagezm = desc;
               UIImageView *imgv = [self->btimagezm viewWithTag:100];
               [imgv setImage:headImage];
           }
           else if(tag==1)
           {
               self->strimagefm = desc;
               UIImageView *imgv = [self->btimagefm viewWithTag:100];
               [imgv setImage:headImage];
           }
           else
           {
               self->strimagezy = desc;
               UIImageView *imgv = [self->btimagezy viewWithTag:100];
               [imgv setImage:headImage];
           }
       }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
        
    }];
}


#pragma mark --

- (void)saveBtnOnTouch:(id)sender {

    if(isAgreement==NO)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseServiceAgreement", nil)];
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DescAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *qyname = cell.valueTextField.text;
    if (!qyname || !(qyname.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseEnterpriseName", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *qynumber = cell.valueTextField.text;
    if (qynumber.length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseEnterpriseNumber", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.valueTextField.text;
    if (name.length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseLegalName", nil)];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *number = cell.valueTextField.text;
    if (number.length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseLegalNumber", nil)];
        return;
    }
    
    
    if(strimagezm.length<5 || strimagefm.length<5)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"qingtianjiashenfenztup", nil)];
        return;
    }
    
    if(strimagezy.length<5)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseBusinessPhoto", nil)];
        return;
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [dicpush setObject:qyname forKey:@"business_name"];
    [dicpush setObject:qynumber forKey:@"licensenum"];
    [dicpush setObject:name forKey:@"legal_name"];
    [dicpush setObject:number forKey:@"legal_id_card"];
    [dicpush setObject:strimagezm forKey:@"legal_id_card_front"];
    [dicpush setObject:strimagefm forKey:@"legal_id_card_back"];
    [dicpush setObject:strimagezy forKey:@"business_img"];
    
    [datacontrol qiyeData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [self performSelector:@selector(showToast) withObject:nil afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
}

- (void)showToast {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"submitSuccess", nil)];
}

@end
