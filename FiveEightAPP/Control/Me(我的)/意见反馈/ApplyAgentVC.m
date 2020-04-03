//
//  ApplyAgentVC.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/30.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "ApplyAgentVC.h"
#import "ApplyAgentDataControl.h"
@interface ApplyAgentVC ()
{
    ApplyAgentDataControl *datacontrol;
    
    NSMutableArray *arrField;
    UITextView *comentView;
}
@end

@implementation ApplyAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:NSLocalizedString(@"feedback", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    datacontrol = [ApplyAgentDataControl new];
    [self drawUI];
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)drawUI
{
    UIScrollView *scvback = [[UIScrollView alloc] init];
    [self.view addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(DEVICE_Width);
        make.top.offset(SafeAreaTopHeight);
        make.height.offset(DEVICE_Height-SafeAreaTopHeight);
    }];
    
    NSArray *arrname = @[NSLocalizedString(@"contacts", nil),NSLocalizedString(@"phoneNumber", nil),@"E-mail"];
    NSArray *arrplatch = @[NSLocalizedString(@"pleaceContacts", nil),NSLocalizedString(@"pleaseNumber", nil),NSLocalizedString(@"pleaseWriteEmail", nil)];
    UIView *viewlast = nil;
    arrField = [NSMutableArray new];
    for(int i = 0 ; i < arrname.count; i++)
    {
        UIView *viewitem = [[UIView alloc] init];
        [scvback addSubview:viewitem];
        [viewitem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.offset(DEVICE_Width);
            make.top.offset(15+55*i);
            make.height.offset(45);
        }];
        UITextField *fielditem = [self drawFieldView:viewitem andname:arrname[i] andplatch:arrplatch[i]];
        [arrField addObject:fielditem];
        if(i==1)
        {
            [fielditem setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if (i==2)
        {
            [fielditem setKeyboardType:UIKeyboardTypeEmailAddress];
        }
        viewlast = viewitem;
    }
    
    
    UITextView *textview = [[UITextView alloc] init];
    [textview setTextAlignment:NSTextAlignmentLeft];
    [textview setTextColor:RGB(30, 30, 30)];
    [textview setFont:[UIFont systemFontOfSize:15]];
    [textview setPlaceholder:NSLocalizedString(@"pleaseOpinion", nil)];
    [textview setBackgroundColor:RGB(245, 245, 245)];
    [scvback addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(viewlast).offset(-15);
        make.top.equalTo(viewlast.mas_bottom).offset(15);
        make.height.offset(150);
    }];
    comentView = textview;
    
    UILabel *lbtishi = [[UILabel alloc] init];
    [lbtishi setText:NSLocalizedString(@"submissionTips", nil)];
    [lbtishi setTextColor:RGB(61, 143, 238)];
    [lbtishi setTextAlignment:NSTextAlignmentLeft];
    [lbtishi setFont:[UIFont systemFontOfSize:15]];
    [lbtishi setNumberOfLines:0];
    [scvback addSubview:lbtishi];
    [lbtishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textview);
        make.top.equalTo(textview.mas_bottom).offset(10);
    }];
    
    UIButton *btsend = [[UIButton alloc] init];
    [btsend setTitle:NSLocalizedString(@"submission", nil) forState:UIControlStateNormal];
    [btsend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btsend.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btsend setBackgroundColor:RGB(234, 58, 60)];
    [btsend.layer setMasksToBounds:YES];
    [btsend.layer setCornerRadius:3];
    [btsend addTarget:self action:@selector(sendComentAction) forControlEvents:UIControlEventTouchUpInside];
    [scvback addSubview:btsend];
    [btsend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(textview);
        make.top.equalTo(lbtishi.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(FIT_WIDTH(300), 45));
    }];
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btsend.mas_bottom).offset(30);
    }];
    
    
}

-(UITextField *)drawFieldView:(UIView *)view andname:(NSString *)strname andplatch:(NSString *)strplatch
{
    
    UITextField *field = [[UITextField alloc] init];
    [field setTextAlignment:NSTextAlignmentLeft];
    [field setTextColor:RGB(30, 30, 30)];
    [field setFont:[UIFont systemFontOfSize:15]];
    [field setPlaceholder:strplatch];
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.equalTo(view);
        make.right.equalTo(view).offset(-15);
    }];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(240, 240, 240)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(field);
        make.right.equalTo(field);
        make.bottom.equalTo(view);
        make.height.offset(1);
    }];
    
    
    return field;
}


///提交
-(void)sendComentAction
{
    UITextField *fieldname = arrField[0];
    UITextField *fieldphone = arrField[1];
    UITextField *fieldemail = arrField[2];
    if(fieldname.text.length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaceContacts", nil)];
        return;
    }
    if(fieldphone.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseNumber", nil)];
        return;
    }
    if(fieldemail.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseWriteEmail", nil)];
        return;
    }
    if(comentView.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseOpinion1", nil)];
        return;
    }
    
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [dicpush setObject:fieldphone.text forKey:@"mobile"];
    [dicpush setObject:fieldname.text forKey:@"contact"];
    [dicpush setObject:fieldemail.text forKey:@"email"];
    [dicpush setObject:comentView.text forKey:@"content"];
    [datacontrol applyagentData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            [self leftBtnOnTouch:nil];
        }else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
}
- (void)showToast {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"submitSuccess", nil)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
