//
//  ModifyNickNameVC.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "ModifyNickNameVC.h"

#import "SVProgressHUD.h"


@interface ModifyNickNameVC ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ModifyNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = RGB(248, 248, 248);
    [self setNavigationBarTitle:NSLocalizedString(@"nickName", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self creatNickView];
}

- (void)creatNickView
{
    UIView *nickView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+15, DEVICE_Width, 49)];
    nickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nickView];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 49)];
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    if (self.nickName.length >0)
    {
        self.textField.text = self.nickName;
    }
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [nickView addSubview:self.textField];
    
//    self.textField.yb_inputCP =  YBInputControlProfile.creat.set_maxLength(16).set_textControlType(YBTextControlType_letter).set_textChanged(^(id obj){
//        NSLog(@"text：%@", [obj valueForKey:@"text"]);
//    });
    
    [self.textField becomeFirstResponder];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
    topLine.backgroundColor = SEPARATORCOLOR;
    [nickView addSubview:topLine];
    
    UIView *belowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48.5, DEVICE_Width, 0.5)];
    belowLine.backgroundColor = SEPARATORCOLOR;
    [nickView addSubview:belowLine];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight+15 +49+8, DEVICE_Width, 14)];
    descLabel.text = NSLocalizedString(@"setNickNameCountChar", nil);
    descLabel.textColor = COL3;
    descLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:descLabel];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveNickName:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:NSLocalizedString(@"changeOk", nil) forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:RGB(234, 58, 60)];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:5.0f];
//    saveBtn.xsz_acceptEventInterval = 1;
//    [saveBtn gradientButtonWithSize:CGSizeMake(DEVICE_Width-80, 50) colorArray:@[(id)DEFAULTCOLOR1,(id)DEFAULTCOLOR2] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftToRight];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(16);
        make.right.equalTo(self.view).with.offset(-16);
        make.height.mas_equalTo(@50);
    }];
}



- (void)leftBtnOnTouch:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)saveNickName:(id)sender {
    if (!self.textField.text || !(self.textField.text.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"qingtianxiexinnicheng", nil)];
        return;
    }
    self.modifyHandler(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textField) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}


@end
