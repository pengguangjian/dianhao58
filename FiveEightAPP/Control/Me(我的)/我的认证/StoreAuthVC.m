//
//  StoreAuthVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/24.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "StoreAuthVC.h"
#import "RealNameAuthVC.h"
#import "UserRenZhengVC.h"
#import "StoreSuthDataControl.h"

@interface StoreAuthVC ()
{
    StoreSuthDataControl *datacontrol;
    NSDictionary *dicSa;
    UIView *viewback;
}
@end

@implementation StoreAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"myCertification", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    
}

-(void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(datacontrol==nil)
    {
        datacontrol = [StoreSuthDataControl new];
    }
    
    [self getStoreAuthInfo];
    
}

///获取认证信息
- (void)getStoreAuthInfo {
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [datacontrol storeSuthData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->dicSa = self->datacontrol.dicSuth;
            [self initView];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
    
    
}

- (void)initView {
    
    if(viewback == nil)
    {
        viewback = [[UIView alloc] init];
        [self.view addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else
    {
        [viewback removeAllSubviews];
    }
    
    
    UILabel *lbtoptishi = [[UILabel alloc] init];
    [lbtoptishi setText:NSLocalizedString(@"certificationCompleteEasier", nil)];
    [lbtoptishi setTextColor:RGB(50, 50, 50)];
    [lbtoptishi setTextAlignment:NSTextAlignmentLeft];
    [lbtoptishi setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:lbtoptishi];
    [lbtoptishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(SafeAreaTopHeight+10);
        make.right.equalTo(viewback).offset(-15);
        make.height.offset(20);
    }];
    
    UIView *viewcenter = [[UIView alloc] init];
    [viewcenter.layer setMasksToBounds:YES];
    [viewcenter.layer setCornerRadius:3];
    [viewcenter.layer setBorderColor:RGB(200, 200, 200).CGColor];
    [viewcenter.layer setBorderWidth:1];
    [viewback addSubview:viewcenter];
    [viewcenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbtoptishi);
        make.top.equalTo(lbtoptishi.mas_bottom).offset(60);
        make.height.offset(300);
    }];
    
    UILabel *lbname = [[UILabel alloc] init];
    [lbname setTextAlignment:NSTextAlignmentCenter];
    [lbname setTextColor:RGB(30, 30, 30)];
    [lbname setText:@"ALOVN"];
    [lbname setFont:[UIFont systemFontOfSize:18]];
    [lbname setBackgroundColor:[UIColor whiteColor]];
    [lbname.layer setMasksToBounds:YES];
    [lbname.layer setCornerRadius:40];
    [lbname.layer setBorderColor:RGB(200, 200, 200).CGColor];
    [lbname.layer setBorderWidth:1];
    [viewback addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewcenter);
        make.centerY.equalTo(viewcenter.mas_top);
        make.size.sizeOffset(CGSizeMake(80, 80));
    }];
    
    NSArray *arrname = @[NSLocalizedString(@"personalAuthentication", nil),NSLocalizedString(@"eerchantCertification", nil)];
    NSArray *arrstate = @[[NSString nullToString:[dicSa objectForKey:@"people_attestation_state"]],[NSString nullToString:[dicSa objectForKey:@"business_attestation_state"]]];
    
    for(int i = 0 ; i < arrname.count; i++)
    {
        UIView *viewitem = [[UIView alloc] init];
        [viewcenter addSubview:viewitem];
        [viewitem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(viewcenter);
            make.height.offset(45);
            make.top.offset(30+55*i);
        }];
        [self drawItemView:viewitem andimage:@"" andname:arrname[i] andisrenz:arrstate[i]];
        [viewitem setTag:i];
        if([arrstate[i] intValue] == 0||[arrstate[i] intValue] == 3)
        {
            UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
            [viewitem addGestureRecognizer:tapitem];
        }
    }
}
/*
 strisrenz 0 未认证； 1 已通过；2 已提交；3未通过
 */

-(void)drawItemView:(UIView *)view andimage:(NSString *)strimage andname:(NSString *)strname andisrenz:(NSString *)strisrenz
{
    UIImageView *imagev = [[UIImageView alloc] init];
    [imagev setImage:[UIImage imageNamed:strimage]];
    [imagev setBackgroundColor:[UIColor grayColor]];
    [view addSubview:imagev];
    [imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(25, 25));
        make.centerY.equalTo(view);
        make.left.offset(20);
    }];
    
    UILabel *lbname = [[UILabel alloc] init];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setTextColor:RGB(30, 30, 30)];
    [lbname setText:strname];
    [lbname setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(imagev.mas_right).offset(10);
        make.width.offset(DEVICE_Width-100);
    }];
    
    if(strisrenz.intValue == 1 || strisrenz.intValue == 2 || strisrenz.intValue == 3)
    {
        UILabel *lbrenz = [[UILabel alloc] init];
        [lbrenz setTextAlignment:NSTextAlignmentRight];
        [lbrenz setTextColor:RGB(30, 30, 30)];
        [lbrenz setText:NSLocalizedString(@"certified", nil)];
        if(strisrenz.intValue == 2)
        {
            [lbrenz setText:NSLocalizedString(@"submitted", nil)];
        }
        else if(strisrenz.intValue == 3)
        {
            [lbrenz setText:NSLocalizedString(@"notPass", nil)];
        }
        
        [lbrenz setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:lbrenz];
        [lbrenz mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view).offset(-15);
            make.width.offset(100);
        }];
    }
    else
    {
        UIImageView *imagevrz = [[UIImageView alloc] init];
        [imagevrz setImage:[UIImage imageNamed:strimage]];
        [imagevrz setBackgroundColor:[UIColor grayColor]];
        [view addSubview:imagevrz];
        [imagevrz mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(15, 15));
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-15);
        }];
        
    }
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(240, 240, 240)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(view).offset(-15);
        make.bottom.equalTo(view);
        make.height.offset(1);
    }];
    
}


-(void)itemAction:(UIGestureRecognizer *)gesture
{
    switch (gesture.view.tag) {
        case 0:
        {///个人
            UserRenZhengVC *vc = [[UserRenZhengVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {///商家
            RealNameAuthVC *vc = [[RealNameAuthVC alloc] initWithNibName:@"RealNameAuthVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)legalPersonBtnOnTouch:(id)sender {
    RealNameAuthVC *vc = [[RealNameAuthVC alloc] initWithNibName:@"RealNameAuthVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
