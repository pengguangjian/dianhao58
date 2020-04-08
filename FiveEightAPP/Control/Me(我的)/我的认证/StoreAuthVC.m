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
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0));
        }];
    }
    else
    {
        [viewback removeAllSubviews];
    }
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self->viewback);
        make.height.offset(3);
    }];
    
    UILabel *lbtoptishi = [[UILabel alloc] init];
    [lbtoptishi setText:NSLocalizedString(@"certificationCompleteEasier", nil)];
    [lbtoptishi setTextColor:RGB(20, 20, 20)];
    [lbtoptishi setTextAlignment:NSTextAlignmentLeft];
    [lbtoptishi setFont:[UIFont systemFontOfSize:16]];
    [lbtoptishi setNumberOfLines:0];
    [viewback addSubview:lbtoptishi];
    [lbtoptishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
        make.right.equalTo(self->viewback).offset(-15);
    }];
    
    NSArray *arrname = @[NSLocalizedString(@"personalAuthentication", nil),NSLocalizedString(@"eerchantCertification", nil)];
    NSArray *arrstate = @[[NSString nullToString:[dicSa objectForKey:@"people_attestation_state"]],[NSString nullToString:[dicSa objectForKey:@"business_attestation_state"]]];
    NSArray *arrimage = @[@"woderenz_geren",@"woderenz_shangjia"];
    
    for(int i = 0 ; i < arrname.count; i++)
    {
        UIView *viewitem = [[UIView alloc] init];
        [viewitem.layer setBorderColor:RGB(234, 234, 234).CGColor];
        [viewitem.layer setBorderWidth:1];
        [viewitem.layer setMasksToBounds:YES];
        [viewitem.layer setCornerRadius:2];
        [viewback addSubview:viewitem];
        [viewitem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.equalTo(self->viewback).offset(-10);
            make.height.offset(45);
            make.top.equalTo(lbtoptishi.mas_bottom).offset(15+55*i);
        }];
        [self drawItemView:viewitem andimage:arrimage[i] andname:arrname[i] andisrenz:arrstate[i]];
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
        make.width.offset(DEVICE_Width-140);
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
        
        [lbrenz setFont:[UIFont systemFontOfSize:12]];
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
        [imagevrz setImage:[UIImage imageNamed:@"ic_stat_left_s"]];
        [view addSubview:imagevrz];
        [imagevrz mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(15, 15));
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-15);
        }];
        
    }
    
//    UIView *viewline = [[UIView alloc] init];
//    [viewline setBackgroundColor:RGB(240, 240, 240)];
//    [view addSubview:viewline];
//    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.right.equalTo(view).offset(-15);
//        make.bottom.equalTo(view);
//        make.height.offset(1);
//    }];
    
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
