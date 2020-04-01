//
//  PublishContentVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/19.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "PublishContentVC.h"
#import "LPlaceholderTextView.h"
#import "JKImagePickerController.h"
#import "ImageCollectionCell.h"
#import "NSString+TimeStamp.h"
#import "UIImage+fixOrientation.h"
#import "ShowImagesController.h"
#import "FESeletTypeView.h"
#import "OpenedCity.h"
#import "CityArea.h"
#import "SelectCityAreaVC.h"
#import "HomeVC.h"
#import "ColumnTypeObj.h"
#import "PublishDataControl.h"

@interface PublishContentVC ()
{
    NSInteger imageIndex;
    int type;
    UIView *bgView;
    NSString *imageUrlStr;//已上传图片地址
    
    UIButton *selectTypeBtn;
    UIButton *selectAreaBtn;
    UIButton *countryCodeBtn;
    UIButton *requestVerityCodeBtn;
    
    NSArray *subTypeArr;
    
    ColumnTypeObj *selectCto;
    OpenedCity *selectCity;
    CityArea *selectArea;
    
    PublishDataControl *datacontrol;
    ///单张图片上传次数
    int ipushimagenumber;
    
}

@property (nonatomic, strong) LPlaceholderTextView *titleTextView;//标题输入框
@property (nonatomic, strong) UILabel *titleWordsLabel;//字数显示控件

@property (nonatomic, strong) LPlaceholderTextView *textView;//内容输入框
@property (nonatomic, strong) UILabel *wordsLabel;//字数显示控件

@property (nonatomic, strong) NSMutableArray    *photoArray;  // 图片数组
@property (nonatomic, strong) NSMutableArray    *editArray;   // 删除后的图片数组

@property (nonatomic, strong) UICollectionView    *photoView;
@property (nonatomic, strong) NSMutableArray    *imageNameArray;   // 上传的图片名
@end

@implementation PublishContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"Publish", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self.commitBtn setBackgroundColor:ORANGEREDCOLOR];
    self.commitBtn.xsz_acceptEventInterval = 1;
    
    //注册通知，在查看大图时，删除操作后的更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPictures:) name:@"REFRESHPICTURES" object:nil];
    
    UITabBarController *tabBarCtrl = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UINavigationController *navi = [tabBarCtrl.viewControllers objectAtIndex:0];
    HomeVC *homeVC = [navi.viewControllers firstObject];
    datacontrol = [PublishDataControl new];
    
    selectCity = homeVC.oc;
    
    imageIndex = 0;
    
    [self getSubColumnType];
    
    [self initView];
    
    
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getSubColumnType {
    NSDictionary *dataDic = @{@"lang":@"zh-cn",
                              @"channelid":_cto.did
    };
    [datacontrol getLanMuSonData:(NSMutableDictionary *)dataDic andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->subTypeArr = [NSMutableArray new];
            self->subTypeArr = [ColumnTypeObj mj_objectArrayWithKeyValuesArray:self->datacontrol.arrlanmuSon];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
}

- (void)initView {
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight-50)];
    scrollView.contentSize = (CGSize){DEVICE_Width,680+75};
    //    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [scrollView setBackgroundColor:RGB(248, 248, 248)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 680+75)];
    [bgView setBackgroundColor:RGB(248, 248, 248)];
    [scrollView addSubview:bgView];
    
    //发布标题控件
    UIView *titleTextViewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULTSECTIONALIGNHEIGHT, DEVICE_Width, 50)];
    titleTextViewContainer.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleTextViewContainer];
    
    self.titleTextView = [[LPlaceholderTextView alloc]initWithFrame:CGRectMake(13, 9, DEVICE_Width - 26, 32)];
    self.titleTextView.font = [UIFont systemFontOfSize:14];
    self.titleTextView.placeholderText = NSLocalizedString(@"pleaseTitle", nil);
    self.titleTextView.placeholderColor = COL3;
    self.titleTextView.textColor = COL1;
    self.titleTextView.scrollEnabled = YES;
    self.titleTextView.delegate = self;
    self.titleTextView.textAlignment = NSTextAlignmentLeft;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [titleTextViewContainer addSubview:self.titleTextView];
    
    self.titleWordsLabel = [[UILabel alloc]init];
    self.titleWordsLabel.text = @"0/50";
    self.titleWordsLabel.font = [UIFont systemFontOfSize:11];
    self.titleWordsLabel.textColor = COL3;
    self.titleWordsLabel.textAlignment = NSTextAlignmentRight;
    [titleTextViewContainer addSubview:self.titleWordsLabel];
    [self.titleWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleTextViewContainer).with.offset(-13);
        make.bottom.equalTo(titleTextViewContainer).with.offset(-9);
        make.size.mas_equalTo(CGSizeMake(70, 14));
    }];
    
    UIView *titleLine = [[UIView alloc] init];
    [titleLine setBackgroundColor:COL4];
    [bgView addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).with.offset(0);
        make.top.equalTo(titleTextViewContainer.mas_bottom).with.offset(-0.5);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 0.5));
    }];
    
    UIView *selectTypeView = [[UIView alloc] init];
    [selectTypeView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:selectTypeView];
    [selectTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(titleTextViewContainer.mas_bottom).with.offset(DEFAULTSECTIONALIGNHEIGHT);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 80));
    }];
    
    UILabel *selectTypeLabel = [[UILabel alloc]init];
    selectTypeLabel.text = [NSString stringWithFormat:@"*%@",NSLocalizedString(@"selectType", nil)];
    selectTypeLabel.font = [UIFont systemFontOfSize:14];
    selectTypeLabel.textColor = COL2;
    selectTypeLabel.textAlignment = NSTextAlignmentLeft;
    [selectTypeView addSubview:selectTypeLabel];
    NSMutableAttributedString *selectTypeAttrString = [[NSMutableAttributedString alloc] initWithString:selectTypeLabel.text];
    [selectTypeAttrString addAttribute:NSFontAttributeName
                                       value:[UIFont systemFontOfSize:15.0f]
                                       range:NSMakeRange(0, 1)];
    [selectTypeAttrString addAttribute:NSForegroundColorAttributeName
                                       value:[UIColor redColor]
                                       range:NSMakeRange(0, 1)];
    selectTypeLabel.attributedText = selectTypeAttrString;
    [selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectTypeView).with.offset(16);
        make.top.equalTo(selectTypeView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-25, 15));
    }];
    
    selectTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectTypeBtn addTarget:self action:@selector(selectTypeBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [selectTypeBtn setTitleColor:COL2 forState:UIControlStateNormal];
    [selectTypeBtn setTitle:NSLocalizedString(@"pleaseSelectType", nil) forState:UIControlStateNormal];
    selectTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [selectTypeBtn setBackgroundColor:[UIColor whiteColor]];
    [selectTypeBtn.layer setMasksToBounds:YES];
    [selectTypeBtn.layer setCornerRadius:5.0];
    [selectTypeBtn.layer setBorderWidth:1.0f];
    [selectTypeBtn.layer setBorderColor:COL3.CGColor];
    selectTypeBtn.xsz_acceptEventInterval = 1;
    [selectTypeView addSubview:selectTypeBtn];
    [selectTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectTypeView).with.offset(16);
        make.top.equalTo(selectTypeLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 30));
    }];
    
    UIView *selectAreaView = [[UIView alloc] init];
    [selectAreaView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:selectAreaView];
    [selectAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(selectTypeView.mas_bottom).with.offset(DEFAULTSECTIONALIGNHEIGHT);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 80));
    }];
    
    UILabel *selectAreaLabel = [[UILabel alloc]init];
    selectAreaLabel.text = [NSString stringWithFormat:@"*%@",NSLocalizedString(@"selectArea", nil)];
    selectAreaLabel.font = [UIFont systemFontOfSize:14];
    selectAreaLabel.textColor = COL2;
    selectAreaLabel.textAlignment = NSTextAlignmentLeft;
    [selectAreaView addSubview:selectAreaLabel];
    NSMutableAttributedString *selectAreaAttrString = [[NSMutableAttributedString alloc] initWithString:selectAreaLabel.text];
    [selectAreaAttrString addAttribute:NSFontAttributeName
                                       value:[UIFont systemFontOfSize:15.0f]
                                       range:NSMakeRange(0, 1)];
    [selectAreaAttrString addAttribute:NSForegroundColorAttributeName
                                       value:[UIColor redColor]
                                       range:NSMakeRange(0, 1)];
    selectAreaLabel.attributedText = selectAreaAttrString;
    [selectAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAreaView).with.offset(16);
        make.top.equalTo(selectAreaView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-25, 15));
    }];
    
    selectAreaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAreaBtn addTarget:self action:@selector(selectAreaBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [selectAreaBtn setTitleColor:COL2 forState:UIControlStateNormal];
    [selectAreaBtn setTitle:NSLocalizedString(@"pleaseSelectArea", nil) forState:UIControlStateNormal];
    [selectAreaBtn setBackgroundColor:[UIColor whiteColor]];
    selectAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [selectAreaBtn.layer setMasksToBounds:YES];
    [selectAreaBtn.layer setCornerRadius:2.0];
    [selectAreaBtn.layer setBorderWidth:1.0f];
    [selectAreaBtn.layer setBorderColor:COL3.CGColor];
    selectAreaBtn.xsz_acceptEventInterval = 1;
    [selectAreaView addSubview:selectAreaBtn];
    [selectAreaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAreaView).with.offset(16);
        make.top.equalTo(selectAreaLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 30));
    }];
    
    
    //发布内容控件
    UIView *textViewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 180+DEFAULTSECTIONALIGNHEIGHT+60, DEVICE_Width, 150)];
    textViewContainer.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:textViewContainer];
    
    self.textView = [[LPlaceholderTextView alloc]initWithFrame:CGRectMake(13, 9, DEVICE_Width - 26, 132)];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.placeholderText = NSLocalizedString(@"pleaseInfoMessage", nil);
    self.textView.placeholderColor = COL3;
    self.textView.textColor = COL1;
    self.textView.scrollEnabled = YES;
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [textViewContainer addSubview:self.textView];
    
    self.wordsLabel = [[UILabel alloc]init];
    self.wordsLabel.text = @"0/20000";
    self.wordsLabel.font = [UIFont systemFontOfSize:11];
    self.wordsLabel.textColor = COL3;
    self.wordsLabel.textAlignment = NSTextAlignmentRight;
    [textViewContainer addSubview:self.wordsLabel];
    [self.wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textViewContainer).with.offset(-13);
        make.bottom.equalTo(textViewContainer).with.offset(-9);
        make.size.mas_equalTo(CGSizeMake(70, 14));
    }];
    
    UIView *midLine = [[UIView alloc] init];
    [midLine setBackgroundColor:COL4];
    [bgView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).with.offset(0);
        make.top.equalTo(textViewContainer.mas_bottom).with.offset(-0.5);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 0.5));
    }];
    
    //反馈图片
    UILabel *imageTitleLabel = [[UILabel alloc]init];
    imageTitleLabel.text = [NSString stringWithFormat: @"    %@",NSLocalizedString(@"addImage", nil)];
    imageTitleLabel.font = [UIFont systemFontOfSize:14];
    imageTitleLabel.textColor = COL2;
    imageTitleLabel.backgroundColor = [UIColor whiteColor];
    imageTitleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:imageTitleLabel];
    [imageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(midLine.mas_bottom).with.offset(DEFAULTSECTIONALIGNHEIGHT);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 35));
    }];
    
    [self.photoView reloadData];
    
    CGRect textFieldBgViewRect = CGRectMake(0, 385+75+10+60, DEVICE_Width, 50);
    for (NSString* optionTitle in @[NSLocalizedString(@"contacts", nil)]) {
        
        UIView *textFieldBgView = [[UIView alloc] initWithFrame:textFieldBgViewRect];
        [textFieldBgView setBackgroundColor:[UIColor whiteColor]];
        [bgView addSubview:textFieldBgView];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 60, 50)];
        descLabel.text = optionTitle;
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textColor = COL1;
        descLabel.backgroundColor = [UIColor whiteColor];
        descLabel.textAlignment = NSTextAlignmentLeft;
        [textFieldBgView addSubview:descLabel];
        
        
        
        UITextField *textField = [[UITextField alloc]init];
        textField.font = [UIFont systemFontOfSize:15];
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //    phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        //    [pwdTextField addTarget:self action:@selector(pwdTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textFieldBgView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textFieldBgView).with.offset(0);
            make.left.equalTo(descLabel.mas_right).with.offset(20);
            make.right.equalTo(textFieldBgView).with.offset(-16);
            make.height.mas_equalTo(@50);
        }];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_Width-16-10, 0, 0, 50)];
        rightLabel.text = @"";
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = [UIColor redColor];
        rightLabel.backgroundColor = [UIColor whiteColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [textFieldBgView addSubview:rightLabel];
        
        if (![optionTitle isEqualToString:@"微信"]) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49.5, DEVICE_Width-16, 0.5)];
            lineView.backgroundColor = bgView.backgroundColor;
            [textFieldBgView addSubview:lineView];
            textField.placeholder = NSLocalizedString(@"pleaceContacts", nil);
            textField.tag = 1000;
        }else{
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49.5, DEVICE_Width-16, 0.5)];
            lineView.backgroundColor = bgView.backgroundColor;
            [textFieldBgView addSubview:lineView];
            textField.placeholder = @"微信";
            textField.tag = 1001;
        }
        
        textFieldBgViewRect.origin.y += 50;
        
        
    }
    
    //手机
    UIView *phoneBgView = [[UIView alloc] init];
    [phoneBgView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(textFieldBgViewRect.origin.y);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 50));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49.5, DEVICE_Width-16, 0.5)];
    lineView.backgroundColor = bgView.backgroundColor;
    [phoneBgView addSubview:lineView];
    
    UILabel *phoneDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 66, 49.5)];
    phoneDescLabel.text = NSLocalizedString(@"phone", nil);
    phoneDescLabel.font = [UIFont systemFontOfSize:15];
    phoneDescLabel.textColor = COL1;
    phoneDescLabel.backgroundColor = [UIColor whiteColor];
    phoneDescLabel.textAlignment = NSTextAlignmentLeft;
    [phoneBgView addSubview:phoneDescLabel];
    NSMutableAttributedString *phoneDescAttrString = [[NSMutableAttributedString alloc] initWithString:phoneDescLabel.text];
    [phoneDescAttrString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:15.0f]
                                 range:NSMakeRange(0, 0)];
    [phoneDescAttrString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:NSMakeRange(0, 0)];
    phoneDescLabel.attributedText = phoneDescAttrString;
    
    countryCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [countryCodeBtn addTarget:self action:@selector(countryCodeBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
    [countryCodeBtn setBackgroundColor:VIEWBGCOLOR];
    [countryCodeBtn setTitleColor:COL2 forState:UIControlStateNormal];
    countryCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [countryCodeBtn.layer setBorderColor:VIEWBGCOLOR.CGColor];
    [countryCodeBtn.layer setCornerRadius:5.0f];
    [phoneBgView addSubview:countryCodeBtn];
    [countryCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneDescLabel.mas_right).with.offset(20);
        make.centerY.mas_equalTo(phoneBgView);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.tag = 1002;
    phoneTextField.placeholder = NSLocalizedString(@"pleaseMobile", nil);
    [phoneBgView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneBgView).with.offset(0);
        make.left.equalTo(countryCodeBtn.mas_right).with.offset(15);
        make.right.equalTo(phoneBgView).with.offset(-16);
        make.height.mas_equalTo(@50);
    }];
    
//    //验证码
//    UIView *verityCodeBgView = [[UIView alloc] init];
//    [verityCodeBgView setBackgroundColor:[UIColor whiteColor]];
//    [bgView addSubview:verityCodeBgView];
//    [verityCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bgView).with.offset(0);
//        make.top.equalTo(phoneBgView.mas_bottom).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 50));
//    }];
//
//    UILabel *verityCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 60, 50)];
//    verityCodeLabel.text = NSLocalizedString(@"yanzhengma", nil);
//    verityCodeLabel.font = [UIFont systemFontOfSize:15];
//    verityCodeLabel.textColor = COL1;
//    verityCodeLabel.backgroundColor = [UIColor whiteColor];
//    verityCodeLabel.textAlignment = NSTextAlignmentLeft;
//    [verityCodeBgView addSubview:verityCodeLabel];
//
//    UITextField *verityCodeTextField = [[UITextField alloc]init];
//    verityCodeTextField.font = [UIFont systemFontOfSize:15];
//    verityCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    verityCodeTextField.leftViewMode = UITextFieldViewModeAlways;
//    verityCodeTextField.tag = 1003;
//    verityCodeTextField.placeholder = NSLocalizedString(@"pleaseCode", nil);
//    [verityCodeBgView addSubview:verityCodeTextField];
//    [verityCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(verityCodeBgView).with.offset(0);
//        make.left.equalTo(verityCodeLabel.mas_right).with.offset(20);
//        make.right.equalTo(verityCodeBgView).with.offset(-16);
//        make.height.mas_equalTo(@50);
//    }];
//    
//    requestVerityCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [requestVerityCodeBtn addTarget:self action:@selector(requestVerityCodeBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
//    requestVerityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    requestVerityCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"getCode", nil)];
//    NSRange strRange = {0,[attrStr length]};
//    [attrStr addAttribute:NSForegroundColorAttributeName value:ORANGEREDCOLOR range:strRange];
//    [requestVerityCodeBtn.layer setBorderColor:DEFAULTCOLOR2.CGColor];
//    [requestVerityCodeBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
//    [verityCodeBgView addSubview:requestVerityCodeBtn];
//    [requestVerityCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bgView).with.offset(-16);
//        make.centerY.mas_equalTo(verityCodeBgView);
//        make.size.mas_equalTo(CGSizeMake(100, 40));
//    }];
    
    
//    UILabel *descLabel = [[UILabel alloc] init];
//    descLabel.font = [UIFont systemFontOfSize:13];
//    descLabel.textColor = COL3;
//    descLabel.text = @"请留下您的邮箱和QQ号码\n小顺子会与您进一步沟通或向您反馈结果";
//    descLabel.numberOfLines = 0;
//    [bgView addSubview:descLabel];
//    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(bgView).with.offset(523+75+4);
//        make.left.equalTo(bgView).with.offset(16);
//        make.right.equalTo(bgView).with.offset(-16);;
//        make.height.mas_equalTo(@40);
//    }];
    
    
    
    
    scrollView.contentSize = (CGSize){DEVICE_Width,680+75};
    bgView.height = 680+75;
    
}

# pragma mark - 点击事件

- (void)requestVerityCodeBtnOnTouch:(UIButton*)btn {
    
    //    BOOL networkStatus =  [NetWorkManager instance].status;
    //    if (!networkStatus) {
    //        [SVProgressHUD showErrorWithStatus:@"网络不可用，请检查网络"];
    //    }
    
//    UIView *superView = btn.superview;
//    UITextField *phoneTextField = (UITextField*)[superView viewWithTag:100];
//
//    BOOL isEffective = [Util validateMobile:phoneTextField.text];
//    if (!isEffective)
//    {
//        [SVProgressHUD showErrorWithStatus:@"手机号码无效"];
//        return;
//    }
//
//    HttpManager *hm = [HttpManager createHttpManager];
//    hm.responseHandler = ^(id responseObject) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
//
//            if ([rd.code isEqualToString:SUCCESS]) {
//
//                [SVProgressHUD showSuccessWithStatus:@"成功请求验证码"];
//                NSLog(@"验证码为：%@",rd.data);
//                //                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"验证码为：%@",rd.data]];
//
//            } else {
//                [SVProgressHUD showErrorWithStatus:rd.msg];
//            }
//        });
//
//    };
//
//    //验证类型1-登录，2-忘记密码，3-忘记支付密码
//    NSDictionary *dataDic = @{@"telphone": phoneTextField.text,
//                              @"type":[NSNumber numberWithInt:1]
//                              };
//    [hm postRequetInterfaceData:dataDic withInterfaceName:@"content/smscode"];
    
    [self toCountdown];
}

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
                
                [attrStr addAttribute:NSForegroundColorAttributeName value:ORANGEREDCOLOR range:strRange];
                [requestVerityCodeBtn.layer setBorderColor:ORANGEREDCOLOR.CGColor];
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

- (void)countryCodeBtnOnTouch:(id)sender {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 上传图片
- (void)sendImage {
    
    UIImage *image = nil;
    id obj = [self.photoArray objectAtIndex:imageIndex];
    if ([obj isKindOfClass:[UIImage class]]) {
        image = obj;
    } else {
        JKAssets *asset = (JKAssets *)obj;
        image = asset.photo;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setObject:@"zh-cn" forKey:@"lang"];
    [dataDic setObject:[User sharedUser].token forKey:@"token"];
    [datacontrol pushImageData:dataDic andimage:image andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [SVProgressHUD dismiss];
        if(state)
        {
            
            if (!self->imageUrlStr) {
                self->imageUrlStr = desc;
            } else {
                self->imageUrlStr = [NSString stringWithFormat:@"%@,%@", self->imageUrlStr, desc];
            }
            self->ipushimagenumber = 0;
            self->imageIndex++;
            if (self->imageIndex == self.photoArray.count) {
                
                [self commitToService];
                
            }else{
                [self sendImage];
            }
        }
        else
        {
            self->ipushimagenumber+=1;
            if(self->ipushimagenumber ==2)
            {
                self->imageIndex++;
            }
            if (self->imageIndex == self.photoArray.count) {
                
                [self commitToService];
                
            }else{
                [self sendImage];
            }
            
        }
        
    }];
}

- (IBAction)commitBtnOnTouch:(id)sender {
    
    [self.view resignFirstResponder];
    
    if (!self.titleTextView.text || !(self.titleTextView.text.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseTitle", nil)];
        return;
    }
    
    if (!selectCto) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseSelectType", nil)];
        return;
    }
    
    if (!selectArea) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseSelectArea", nil)];
        return;
    }
    
    if (!self.textView.text || !(self.textView.text.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseInfoMessage", nil)];
        return;
    }
    
    UITextField *tf = [self.view viewWithTag:1000];
    NSString *contactStr = tf.text;
    
    tf = [self.view viewWithTag:1001];
    NSString *wxStr = tf.text;
    
    tf = [self.view viewWithTag:1002];
    NSString *phoneStr = tf.text;
    
    tf = [self.view viewWithTag:1003];
    NSString *verityCodeStr = tf.text;
    
//    if (!(emalStr.length>0 || wxStr.length>0 || phoneStr.length>0)) {
//        [SVProgressHUD showErrorWithStatus:@"请至少填写一种联系方式"];
//        return;
//    }
    
    if (!contactStr || !(contactStr.length>0))
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaceContacts", nil)];
        return;
    }
    
    if (![Util validateMobile:phoneStr]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"pleaseMobile", nil)];
            return;
    }
    if (self.photoArray.count>0&&imageIndex==0) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"shangchuantupianzhong", nil)];
        [self sendImage];
    }else{
        [self commitToService];
    }
    
}
#pragma mark - 提交
- (void)commitToService {
    UITextField *tf = [self.view viewWithTag:1000];
    NSString *contactStr = tf.text;
    
    tf = [self.view viewWithTag:1001];
    NSString *wxStr = tf.text;
    
    tf = [self.view viewWithTag:1002];
    NSString *phoneStr = tf.text;
    
    tf = [self.view viewWithTag:1003];
    NSString *verityCodeStr = tf.text;
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//    [dataDic setObject:@"zh-cn" forKey:@"lang"];
    [dataDic setObject:[User sharedUser].token forKey:@"token"];
    [dataDic setObject:selectCity.id forKey:@"cityid"];
    [dataDic setObject:selectArea.id forKey:@"areaid"];
    [dataDic setObject:selectCto.id forKey:@"channelid"];
    [dataDic setObject:self.titleTextView.text forKey:@"title"];
    if (imageUrlStr.length>0) {
        [dataDic setObject:imageUrlStr forKey:@"image"];
    }
    if (contactStr.length>0) {
        [dataDic setObject:contactStr forKey:@"contact"];
    }
    if (wxStr.length>0) {
    }
    if (phoneStr.length>0) {
        [dataDic setObject:phoneStr forKey:@"mobile"];
    }
    if (verityCodeStr.length>0) {
    }
    [dataDic setObject:[Util getIPAddress:YES] forKey:@"ip"];
    
    [dataDic setObject:self.textView.text forKey:@"addon[content]"];
    
    [datacontrol pushData:dataDic andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
       
        if(state)
        {
            [self performSelector:@selector(showDialog) withObject:nil/*可传任意类型参数*/ afterDelay:1];
//            [self leftBtnOnTouch:nil];
            [Util changeRootVC];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
        
    }];
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSRange range;
    range.location = 0;
    range.length  = 0;
    textView.selectedRange = range;
}


#pragma mark - 字数限制处理

/**
 *  @brief  字数限制处理
 *
 *  @param textView UITextView
 *  @param range    NSRange
 *  @param text     NSString
 *
 *  @return BOOL
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView == self.titleTextView && textView.text.length >= 50 && text.length > range.length) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView == self.textView && textView.text.length >= 20000 && text.length > range.length) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

/**
 *  @brief  字数限制处理
 *
 *  @param textView UITextView
 */
- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = [textView.text length];
    
    
    if (textView == self.titleTextView) {
        if (_titleTextView.markedTextRange == nil  && number > 50) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tishi", nil) message:NSLocalizedString(@"zifugeshubunengdayu", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"queding", nil) otherButtonTitles:nil];
            [alert show];
            _titleTextView.text = [textView.text substringToIndex:50];
        }
        
        self.titleWordsLabel.text = [NSString stringWithFormat:@"%zi/50",number];
        
        return;
    }
    
    
    if (textView.markedTextRange == nil  && number > 20000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tishi", nil) message:NSLocalizedString(@"zifugeshubunengdayu2", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"queding", nil) otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:50];
    }
    
    self.wordsLabel.text = [NSString stringWithFormat:@"%zi/20000",number];
}


#pragma mark - 懒加载
- (UICollectionView*)photoView {
    
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 10.0;
        layout.minimumLineSpacing = 10.0;
        
        _photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 385+60, DEVICE_Width, 75) collectionViewLayout:layout];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.opaque = NO;
        [bgView addSubview:_photoView];
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:COL4];
        [_photoView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_photoView).with.offset(0);
            make.bottom.equalTo(_photoView).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 0.5));
        }];
        
        [_photoView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
    }
    return _photoView;
}

- (NSMutableArray *)editArray {
    if (!_editArray) {
        _editArray = [NSMutableArray array];
    }
    return _editArray;
}

- (NSMutableArray *)photoArray {
    
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
        
    }
    return _photoArray;
}

- (NSMutableArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray =[NSMutableArray array];
    }
    return _imageNameArray;
}

#pragma mark -


/**
 *  图片选择
 */
- (void)selectPhoto
{
    NSInteger m = 0;
    for (id obj in self.photoArray) {
        if ([obj isKindOfClass:[UIImage class]] ) {  // 拍的照片
            m++;
        }
    }
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 5-m;
    if (self.photoArray.count <= 0) {
        imagePickerController.selectedAssetArray = nil;
    } else {
        NSMutableArray *mutArr = [NSMutableArray array];
        for (id obj in self.photoArray) {
            if ([obj isKindOfClass:[JKAssets class]]) {
                [mutArr addObject:obj];
            }
        }
        if (mutArr.count == 0) {
            imagePickerController.selectedAssetArray = nil;
        } else {
            imagePickerController.selectedAssetArray = mutArr;
        }
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - ===================== UICollectionViewDataSource =====================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.photoArray.count >= 5) {
        return self.photoArray.count;
    }else{
        return self.photoArray.count+1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //在末尾添加“+”图片按钮
    if (indexPath.row == self.photoArray.count) {
        
        UIImage *addImage = [UIImage imageNamed:@"ic_addImage"];
        
        ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        cell.imageView.image = addImage;
        return cell;
    }
    
    //选择的图片
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    id obj = [self.photoArray objectAtIndex:indexPath.item];
    if ([obj isKindOfClass:[UIImage class]]) {
        cell.imageView.image = obj;
    } else {
        JKAssets *asset = (JKAssets *)obj;
        cell.imageView.image = asset.photo;
    }
    
    return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(12.5, 12.5, -12.5, -12.5);
}

#pragma mark - ===================== UICollectionViewDelegate =====================

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.editArray removeAllObjects];
    
    //选中添加图片按钮
    if (self.photoArray.count == indexPath.row) {
        [self selectPhoto];
        return;
    }
    
    //选中已添加的图片
    ShowImagesController *imageVC = [[ShowImagesController alloc] init];
    imageVC.imageArray = self.photoArray;
    imageVC.imageNameArray = self.imageNameArray;
    imageVC.selectedIndex = indexPath.item;
    imageVC.isShowDelBtn = YES;
    imageVC.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:imageVC animated:YES completion:nil];
    
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 图片和视频只能上传一种，删除视频 和 图片(图片限制上传5张 为避免第二次选中重复图片，每次选图片，就把上次选的删除)
    if (assets.count > 0 && self.photoArray.count > 0) {
        // 删除图片
        NSString *filePath = [self getDocumentDirectory];
        
        if ([fm fileExistsAtPath:filePath]) {
            
            NSInteger n = self.photoArray.count;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
            
            for (NSUInteger idx = 0; idx < n; idx++) {
                id obj = [self.photoArray objectAtIndex:idx];
                
                // 只删除选择的相册的图片  不删除拍照的图片
                if ([obj isKindOfClass:[JKAssets class]]) {
                    NSString *filname = self.imageNameArray[idx];
                    NSError *error = nil;
                    BOOL res = [fm removeItemAtPath:[filePath stringByAppendingPathComponent:filname] error:&error];
                    if (!res) {
                        ALOGDebug(@"删除失败 error = %@", error);
                    }
                }
                else {
                    [array addObject:obj];
                    [array1 addObject:self.imageNameArray[idx]];
                }
            }
            
            [self.photoArray removeAllObjects];
            [self.imageNameArray removeAllObjects];
            [self.photoArray addObjectsFromArray:array];
            [self.imageNameArray addObjectsFromArray:array1];
        }
    }
    
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block JKAssets *assets = (JKAssets *)obj;
        
        __block UIImage *result = assets.photo;
        
        if (!result) {
            ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            
            
            [lib assetForURL:assets.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    assets.photo = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    [self.imageNameArray addObject:assets.assetPropertyURL.absoluteString];
                    if (![self.photoArray containsObject:assets]) {
                        [self.photoArray addObject:assets];
                        [self.photoView reloadData];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
        NSData *data;
        if (UIImagePNGRepresentation(result) == nil) {
            data = UIImageJPEGRepresentation(result, 1);
        } else {
            data = UIImagePNGRepresentation(result);
        }
        
        // 保存图片
        NSString *filePath = [self getDocumentDirectory];
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *fileName = [NSString stringWithFormat:@"image-%lu-%@.png", (unsigned long)idx, [NSString getUniqueStrByUUID]];
        BOOL res = [data writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:NO];
        if (!res) {
            ALOGDebug(@"存储图片失败");
        } else {
            // 刷新界面
            [self.imageNameArray addObject:fileName];
            if (![self.photoArray containsObject:assets]) {
                [self.photoArray addObject:assets];
            }
        }
    }];
    
    [self.photoView reloadData];
    
}

/**
 *  通知更新数据及UI
 *
 *  @param noti NSNotification
 */
- (void)refreshPictures:(NSNotification *)noti {
    [self.editArray addObjectsFromArray:noti.object];
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:self.editArray];
    
    [self.photoView reloadData];
}

/**
 *  保存／删除图片的路径
 *
 *  @return 路径
 */
- (NSString *)getDocumentDirectory {
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:@"YDImage/"];
    return path;
}

#pragma mark - 上传图片

#pragma mark -

- (void)showDialog {
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"pushSuccess", nil)];
}

- (void)selectTypeBtnOnTouch:(id)sender {
    
    [self.view endEditing:YES];
    
    FESeletTypeView *seletTypeView = [FESeletTypeView sharedView:subTypeArr];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:seletTypeView];
    
    seletTypeView.handler = ^(id  _Nonnull type) {
        
        self->selectCto = type;
        [self->selectTypeBtn setTitle:selectCto.name forState:UIControlStateNormal];
        
    };
    [seletTypeView show];
    
}

- (void)selectAreaBtnOnTouch:(id)sender {
    
    [self.view endEditing:YES];
    
    SelectCityAreaVC *vc = [[SelectCityAreaVC alloc] initWithNibName:@"SelectCityAreaVC" bundle:nil];
    vc.isFormPublish = NO;
    vc.oc = selectCity;
    vc.handler = ^(id  _Nonnull cityAreaObj) {
        selectArea = cityAreaObj;
        
        [selectAreaBtn setTitle:selectArea.name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
