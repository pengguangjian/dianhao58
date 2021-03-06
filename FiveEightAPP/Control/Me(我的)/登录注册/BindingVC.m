//
//  BindingVC.m
//  FiveEightAPP
//
//  Created by Mac on 2020/4/2.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "BindingVC.h"
#import "LoginDataControl.h"
#import "LoginUser.h"
#import "SmsProtoctFunction.h"

#import "WebViewVC.h"

@interface BindingVC () <UITextFieldDelegate>
{
    UIScrollView *scvback;
    
    UIButton *requestVerityCodeBtn;
    
    NSMutableArray *arrFiled;
    
    LoginDataControl *datacontrol;
    ///手机号是否存在
    BOOL isphone;
    
}
@end

@implementation BindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBarTitle:NSLocalizedString(@"accountBinding", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    
    self.navigationItem.hidesBackButton = YES;
    
    [self drawUI];
    
    datacontrol = [LoginDataControl new];
    
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)drawUI
{
    self.view.backgroundColor = [UIColor whiteColor];
     
     scvback = [[UIScrollView alloc] init];
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
        make.centerX.equalTo(self->scvback);
        make.size.mas_equalTo(CGSizeMake(140/2.0, 140/2.0));
    }];
     
     
     UIView *viewinfo = [[UIView alloc] init];
     [viewinfo setBackgroundColor:[UIColor whiteColor]];
     [scvback addSubview:viewinfo];
     [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.offset(0);
         make.width.offset(DEVICE_Width);
         make.top.equalTo(logoImageView.mas_bottom).offset(30);
     }];
     [self drawInfoView:viewinfo];
     
     
     [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(viewinfo.mas_bottom).offset(30);
     }];
    
}


-(void)drawInfoView:(UIView *)view
{
    
    NSArray *arrplatch = @[NSLocalizedString(@"pleaseMobile", nil),NSLocalizedString(@"nickName", nil),NSLocalizedString(@"pleaseEmail", nil),NSLocalizedString(@"pleasePassWord", nil),NSLocalizedString(@"PleaseToPassWord", nil)];
    arrFiled = [NSMutableArray new];
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
        if(i==3||i==4)
        {
            [fieldname setSecureTextEntry:YES];
            [fieldname setKeyboardType:UIKeyboardTypeASCIICapable];
        }
        else if (i==2)
        {
            [fieldname setKeyboardType:UIKeyboardTypeASCIICapable];
            [fieldname setDelegate:self];
            [fieldname setTag:2];
        }
        else if (i==0)
        {
            [fieldname setKeyboardType:UIKeyboardTypeNumberPad];
        }
        [arrFiled addObject:fieldname];
        if(_isbangding)
        {
            if(i==1)
            {
                [fieldname setText:_strnickname];
            }
        }
        if(i>0)
        {
            [viewname setHidden:YES];
        }
    }
    
    UIView *viewcode = [[UIView alloc] init];
    [view addSubview:viewcode];
    [viewcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.offset(10+55*1);
        make.height.offset(55);
    }];
    UITextField *fieldCode = [self drawInputView:viewcode andimage:@"login_icon_code" andplatch:NSLocalizedString(@"pleaseCode", nil)];
    [arrFiled addObject:fieldCode];
    [fieldCode setKeyboardType:UIKeyboardTypeNumberPad];
    
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
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(@120);
    }];
    
    ///
    UIButton *shortcutLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shortcutLoginBtn addTarget:self action:@selector(resignBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    shortcutLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [shortcutLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shortcutLoginBtn setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    [shortcutLoginBtn setBackgroundColor:RGB(234, 58, 60)];
    [shortcutLoginBtn.layer setMasksToBounds:YES];
    [shortcutLoginBtn.layer setCornerRadius:5.0f];
//    shortcutLoginBtn.xsz_acceptEventInterval = 1;
//    [shortcutLoginBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [view addSubview:shortcutLoginBtn];
    [shortcutLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(@50);
        make.top.equalTo(viewcode.mas_bottom).offset(30);
    }];
    
    
    
    
    UILabel *protocolLabel = [[UILabel alloc] init];
    protocolLabel.text = NSLocalizedString(@"yiyuedubtyalonxieyi", nil);
    protocolLabel.numberOfLines = 0;
    protocolLabel.textColor = COL3;
    protocolLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shortcutLoginBtn.mas_bottom).with.offset(10);
        make.left.equalTo(shortcutLoginBtn.mas_left);
        make.right.equalTo(shortcutLoginBtn.mas_right);
    }];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:protocolLabel.text];
    NSRange range = [protocolLabel.text rangeOfString:NSLocalizedString(@"shiyongxiyijishengming", nil)];
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
    
    UIButton *userAgreementBtn =[[UIButton alloc]init];
    [userAgreementBtn addTarget:self action:@selector(userAgreementBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:userAgreementBtn];
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(protocolLabel);
        make.bottom.equalTo(protocolLabel);
        make.left.equalTo(protocolLabel);
        make.right.equalTo(protocolLabel);
    }];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(userAgreementBtn.mas_bottom).offset(50);
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
    
    UITextField *fieldphone = arrFiled[0];
    if (fieldphone.text.length<3)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    [btn setUserInteractionEnabled:NO];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:fieldphone.text forKey:@"mobile"];

    [datacontrol phoneIsAccountPushData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       if(state)
       {
           if([[self->datacontrol.dicPhoneIs objectForKey:@"code"] intValue] == 1)
           {///手机号已存在
               self->isphone = YES;
               
           }
           else
           {
               self->isphone = NO;
               for(UITextField *field in self->arrFiled)
               {
                   [field.superview setHidden:NO];
               }
               UITextField *field = self->arrFiled.lastObject;
               UIView *viewsupertemp = field.superview;
               [viewsupertemp mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.top.offset(10+55*5);
               }];
           }
           [self getCodeData:dicpush andsender:btn];
       }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
}
-(void)getCodeData:(NSMutableDictionary *)dicpush andsender:(UIButton *)btn
{
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

#pragma mark - 协议点击
-(void)userAgreementBtnOnTouch
{
    WebViewVC *vc = [[WebViewVC alloc] initLoadRequest:NSLocalizedString(@"shiyongxieyijishengm", nil) initWithTitle:@"frontend.page/registration"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 注册
-(void)resignBtnOnTouch
{
    UITextField *fieldphone = arrFiled[0];
    UITextField *fieldname = arrFiled[1];
    UITextField *fieldemail = arrFiled[2];
    UITextField *fieldpass = arrFiled[3];
    UITextField *fieldpassok = arrFiled[4];
    UITextField *fieldcode = arrFiled[5];
    
    if([fieldphone.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
        return;
    }
    
    if([fieldcode.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseCode", nil)];
        return;
    }
    
    if(isphone==NO)
    {
        if([fieldname.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"nickName", nil)];
            return;
        }
        if([fieldemail.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseEmail", nil)];
            return;
        }
        
        if([fieldpass.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleasePassWord", nil)];
            return;
        }
        if(![fieldpass.text isEqualToString:fieldpassok.text])
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseNewToPassWord", nil)];
            return;
        }
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    if(isphone==NO)
    {
        [dicpush setObject:fieldpass.text forKey:@"password"];
        [dicpush setObject:fieldemail.text forKey:@"email"];
        [dicpush setObject:fieldname.text forKey:@"name"];
    }
    [dicpush setObject:fieldphone.text forKey:@"mobile"];
    [dicpush setObject:fieldcode.text forKey:@"smscode"];
    [dicpush setObject:[_dicBangDing objectForKey:@"platform"] forKey:@"platform"];
    [dicpush setObject:[_dicBangDing objectForKey:@"code"] forKey:@"code"];
    
    [self bangDingPush:dicpush];
    
    
    
}
///绑定提交数据
-(void)bangDingPush:(NSMutableDictionary *)dicpush
{
    [datacontrol otherLoginBangDingPushData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            LoginUser *loginUser = [LoginUser mj_objectWithKeyValues:self->datacontrol.dicOtherLoginBD];
            [loginUser saveUser];
            //成功登录
            [Util changeRootVC];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
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
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"getCode", nil)];
                NSRange strRange = {0,[attrStr length]};
                
                [attrStr addAttribute:NSForegroundColorAttributeName value:DEFAULTCOLOR2 range:strRange];
                [requestVerityCodeBtn.layer setBorderColor:DEFAULTCOLOR2.CGColor];
                [requestVerityCodeBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
                requestVerityCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{

                NSString *title = [NSString stringWithFormat:@"%@s%@",strTime,NSLocalizedString(@"chongxinhuoqu", nil)];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
                NSRange strRange = {0,[attrStr length]};
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:strRange];
                [requestVerityCodeBtn.layer setBorderColor:RGB(153, 153, 153).CGColor];
                [requestVerityCodeBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
                requestVerityCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2)
    {
        if([Util isChinese:string])
        {
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (action == @selector(copy:) || action == @selector(paste:)) {
//        return NO;
//    }
    return NO;
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
