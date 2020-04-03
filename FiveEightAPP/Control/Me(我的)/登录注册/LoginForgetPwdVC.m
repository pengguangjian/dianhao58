//
//  LoginForgetPwdVC.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "LoginForgetPwdVC.h"
#import "LoginDataControl.h"
#import "SmsProtoctFunction.h"

@interface LoginForgetPwdVC ()
{
    UIButton *requestVerityCodeBtn;
    LoginDataControl *datacontrol;
    
    NSMutableArray *arrField;
    
}
@end

@implementation LoginForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if(_ischangePassword)
    {
        [self setNavigationBarTitle:NSLocalizedString(@"xiugaimima", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    }
    else
    {
        [self setNavigationBarTitle:NSLocalizedString(@"forgetPassword", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    [self drawUI];
    datacontrol=[LoginDataControl new];
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)drawUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scvback = [[UIScrollView alloc] init];
    [self.view addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(DEVICE_Width);
        make.top.offset(SafeAreaTopHeight);
        make.height.offset(DEVICE_Height);
        
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"log_log"];
    [scvback addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.centerX.equalTo(scvback);
        make.size.mas_equalTo(CGSizeMake(140/2.0, 140/2.0));
    }];
    
    
    UIView *viewinfo = [[UIView alloc] init];
    [viewinfo setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewinfo];
    [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(DEVICE_Width);
        make.top.equalTo(logoImageView.mas_bottom).offset(30);
    }];
    [self drawInfoView:viewinfo];
    
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewinfo).offset(30);
    }];
    
}


-(void)drawInfoView:(UIView *)view
{
    
    NSArray *arrplatch = @[NSLocalizedString(@"pleaseMobile", nil),NSLocalizedString(@"pleasePassWord", nil),NSLocalizedString(@"PleaseToPassWord", nil)];
    arrField = [NSMutableArray new];
    for(int i = 0 ; i < arrplatch.count; i++)
    {
        UIView *viewname = [[UIView alloc] init];
        [view addSubview:viewname];
        [viewname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.offset(10+55*i);
            make.height.offset(55);
        }];
        UITextField *fieldname = [self drawInputView:viewname andimage:@"login_icon_cell" andplatch:arrplatch[i]];
        [fieldname setTag:100+i];
        if(i==1 || i==2)
        {
            [fieldname setSecureTextEntry:YES];
        }
        [arrField addObject:fieldname];
    }
    
    UIView *viewcode = [[UIView alloc] init];
    [view addSubview:viewcode];
    [viewcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.offset(10+55*3);
        make.height.offset(55);
    }];
    UITextField *fieldCode = [self drawInputView:viewcode andimage:@"login_icon_code" andplatch:NSLocalizedString(@"pleaseCode", nil)];
    [arrField addObject:fieldCode];
    
    
    requestVerityCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestVerityCodeBtn addTarget:self action:@selector(requestVerityCodeBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    requestVerityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [requestVerityCodeBtn setTitle:NSLocalizedString(@"getCode", nil) forState:UIControlStateNormal];
    [requestVerityCodeBtn setBackgroundColor:RGB(234, 58, 60)];
    [requestVerityCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestVerityCodeBtn.layer setCornerRadius:3];
    [requestVerityCodeBtn.layer setMasksToBounds:YES];
    [viewcode addSubview:requestVerityCodeBtn];
    [requestVerityCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewcode).with.offset(-25);
        make.centerY.mas_equalTo(viewcode).offset(-5);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    
    ///
    UIButton *shortcutLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shortcutLoginBtn addTarget:self action:@selector(resignBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    shortcutLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [shortcutLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shortcutLoginBtn setTitle:NSLocalizedString(@"queding", nil) forState:UIControlStateNormal];
    [shortcutLoginBtn setBackgroundColor:RGB(234, 58, 60)];
    [shortcutLoginBtn.layer setMasksToBounds:YES];
    [shortcutLoginBtn.layer setCornerRadius:5.0f];
    [view addSubview:shortcutLoginBtn];
    [shortcutLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(@50);
        make.top.equalTo(viewcode.mas_bottom).offset(30);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(shortcutLoginBtn.mas_bottom).offset(30);
    }];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    
    
}

-(UITextField *)drawInputView:(UIView *)view andimage:(NSString *)strimage andplatch:(NSString *)strplatch
{
    UITextField *Field = [[UITextField alloc]init];
    Field.font = [UIFont systemFontOfSize:15];
    Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    Field.leftViewMode = UITextFieldViewModeAlways;
    Field.placeholder = strplatch;
    Field.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:Field];
    [Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.right.equalTo(view).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    UIView *phoneTextFieldBelowLine = [[UIView alloc]init];
    phoneTextFieldBelowLine.backgroundColor = SEPARATORCOLOR;
    [view addSubview:phoneTextFieldBelowLine];
    [phoneTextFieldBelowLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.equalTo(Field.mas_bottom).with.offset(5);
        make.left.equalTo(Field.mas_left);
        make.right.equalTo(Field.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
    return Field;
}

#pragma mark - 获取验证码
- (void)requestVerityCodeBtnOnTouch:(UIButton*)btn {
    UITextField *fieldphone = arrField[0];
    if (fieldphone.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    [btn setUserInteractionEnabled:NO];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:fieldphone.text forKey:@"mobile"];


    [SmsProtoctFunction smsRegionalData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [SVProgressHUD showSuccessWithStatus:desc];
            [self toCountdown];
        }
        else
        {
            [btn setUserInteractionEnabled:YES];
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
}

#pragma mark - 确定
-(void)resignBtnOnTouch
{
 
    UITextField *fieldphone = arrField[0];
    UITextField *fieldpwd = arrField[1];
    UITextField *fieldpwdnew = arrField[2];
    UITextField *fieldcode= arrField[3];
    
    if(fieldphone.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    if(fieldpwd.text.length<6)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseNewPassWord", nil)];
        return;
    }
    if(![fieldpwdnew.text isEqualToString:fieldpwd.text])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseNewToPassWord", nil)];
        return;
    }
    if(fieldpwd.text.length<4)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseCode", nil)];
        return;
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:fieldphone.text forKey:@"mobile"];
    [dicpush setObject:fieldpwd.text forKey:@"newpassword"];
    [dicpush setObject:fieldcode.text forKey:@"smscode"];
    
    
    [datacontrol resetpwdData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        
        if(state)
        {
            [self performSelector:@selector(showToast) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
        
        
    }];
}
- (void)showToast {
    if(_ischangePassword)
    {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"changeSuccess", nil)];
    }
    
}

#pragma mark - //倒计时时间
- (void)toCountdown {
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self->requestVerityCodeBtn setTitle:NSLocalizedString(@"getCode", nil) forState:UIControlStateNormal];
                self->requestVerityCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{

                NSString *title = [NSString stringWithFormat:@"%@s%@",strTime,NSLocalizedString(@"chongxinhuoqu", nil)];
                [self->requestVerityCodeBtn setTitle:title forState:UIControlStateNormal];
                self->requestVerityCodeBtn.userInteractionEnabled = NO;
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}



@end
