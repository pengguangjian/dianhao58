//
//  ContentDetailVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/19.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "ContentDetailVC.h"
#import "ShowImagesController.h"
#import "CommentFloorHostCell.h"
#import "CommentOtherCell.h"
#import "FESendCommentView.h"
#import "PublishContentObj.h"
#import "ContentDetailDatacontrol.h"
#import "BanKuaiModel.h"
#import "HomeDetailContentModel.h"
#import "MyOrderCellOtherActionView.h"

#import "MDBwebVIew.h"

@interface ContentDetailVC ()<CommentFloorHostCellDelegate,FESendCommentViewDelegate,MyOrderCellOtherActionViewDelegate,MDBwebDelegate>
{
    UIView *headerView;
    UIView *alignTopView;
    
    float contentSizeHeight;
    
    NSArray *photoArr;
    
    ///详情
    BanKuaiModel *modeldetail;
    ///评论数据
    NSMutableArray *commentArr;
    ///1收藏
    NSString *strcollect;
    
    ContentDetailDatacontrol *datacontrol;
    
    MyOrderCellOtherActionView *cellOtherActionView;
    
}

@property (nonatomic , retain) UIButton *btcollect;

@end

@implementation ContentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"details", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight-50)];
    self.tableView.separatorColor = SEPARATORCOLOR;
    
     self.page = 1;
    datacontrol = [ContentDetailDatacontrol new];
    [self getContentData];
    [self loadFirstData];
}

- (void)leftBtnOnTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getContentData {
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:_contentId forKey:@"id"];
    if(![User isNeedLogin])
    {
        [dicpush setObject:[User sharedUser].user_id forKey:@"user_id"];
    }
    
    
    [datacontrol detailData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            self->modeldetail = [BanKuaiModel dicToModelValue:self->datacontrol.dicdetail];
            self->strcollect = self->datacontrol.favoreted;
            [self initView];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
    
}

- (void)initView {
    
    contentSizeHeight = 0;
    
    self.title = NSLocalizedString(@"details", nil);
    
    [self.contactBtn setTitle:NSLocalizedString(@"callUp", nil) forState:UIControlStateNormal];
    [self.contactBtn setBackgroundColor:ORANGEREDCOLOR];
    [self.focusPNBtn setBackgroundColor:ORANGEREDCOLOR];
    
     headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight-50)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableHeaderView = headerView;
    
    
    //发布分类，时间，地点
    UIView *topView = [[UIView alloc] init];
    [headerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headerView).with.offset(0);
        make.top.equalTo(self->headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 90));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = modeldetail.title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = COL1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(16);
        make.top.equalTo(topView).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 15));
    }];
    
    
    UILabel *publishTimeLabel = [[UILabel alloc]init];
    publishTimeLabel.text = [NSString stringWithFormat:@"%@ %@", modeldetail.publishtime_text,NSLocalizedString(@"pushPublic", nil)];
    publishTimeLabel.font = [UIFont systemFontOfSize:12];
    publishTimeLabel.textColor = COL3;
    publishTimeLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:publishTimeLabel];
    [publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(16);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 12));
    }];
    
    
    UIImageView *imagvrz = [[UIImageView alloc] init];
    [imagvrz setImage:[UIImage imageNamed:@""]];
    [topView addSubview:imagvrz];
    [imagvrz mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.top.equalTo(titleLabel.mas_top);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    if(modeldetail.authentication_status.intValue == 1)
    {
        [imagvrz setImage:[UIImage imageNamed:@"gerenrenzhengSuccess"]];
    }
    else if(modeldetail.authentication_status.intValue == 2)
    {
        [imagvrz setImage:[UIImage imageNamed:@"qiyerenzhengSuccess"]];
    }
    
    
    UILabel *publishCityLabel = [[UILabel alloc]init];
    if(modeldetail.city_name.length>0)
    {
        publishCityLabel.text = [NSString stringWithFormat:@"%@",modeldetail.city_name];
        if (modeldetail.area_name.length>0)
        {
            publishCityLabel.text = [NSString stringWithFormat:@"%@ • %@",modeldetail.city_name,modeldetail.area_name];
        }
    }
    else if (modeldetail.area_name.length>0)
    {
        publishCityLabel.text = [NSString stringWithFormat:@"%@",modeldetail.area_name];
    }
    
    publishCityLabel.font = [UIFont systemFontOfSize:12];
    publishCityLabel.textColor = COL3;
    publishCityLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:publishCityLabel];
    [publishCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(16);
        make.top.equalTo(publishTimeLabel.mas_bottom).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 12));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SEPARATORCOLOR;
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(16);
        make.bottom.equalTo(topView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-16, 0.5));
    }];
    
    contentSizeHeight += 90;
    
    //联系方式
    UIView *contactView= [[UIView alloc] init];
    [headerView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headerView).with.offset(0);
        make.top.equalTo(topView.mas_bottom).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 77+32));
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 35+20));
    }];
    
    [self addContactView:[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"mobile", nil),[Util getConcealPhoneNumber:modeldetail.mobile]] withAlignTop:20 withSuperView:contactView];
    
    contentSizeHeight += 35+20;//77+32;
    
    //发布内容
    NSString *content = modeldetail.content;
    MDBwebVIew *webview = [[MDBwebVIew alloc] init];
    [webview setDelegate:self];
    [headerView addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headerView).with.offset(16);
        make.top.equalTo(contactView.mas_bottom).with.offset(0);
        make.width.offset(DEVICE_Width-32);
        make.height.offset(1);
    }];
    [webview refreshHtml:content];
    
    
    
    alignTopView = webview;
    
    photoArr = modeldetail.image;
    NSInteger index = 0;
    for (NSString *urlStr in photoArr) {
        if (urlStr.length>0) {
            [self addImageView:urlStr withTag:index];
            index++;
        }
    }
    
    
    //推广内容
    NSString *adContent = NSLocalizedString(@"detailCommentdetail", nil);
    
    UILabel *adContentLabel = [[UILabel alloc]init];
    adContentLabel.text = adContent;
    adContentLabel.font = [UIFont systemFontOfSize:17];
    adContentLabel.textColor = COL1;
//    [adContentLabel setBackgroundColor:[UIColor redColor]];
    adContentLabel.numberOfLines = 0;
    adContentLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:adContentLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为8
    [paragraphStyle  setLineSpacing:8];
    NSMutableAttributedString  *adContentAttr = [[NSMutableAttributedString alloc] initWithString:adContentLabel.text];
    [adContentAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [adContentLabel.text length])];
    adContentLabel.attributedText = adContentAttr;
    
    //计算高度
    CGSize adTextSize = [adContentLabel.text boundingRectWithSize:CGSizeMake(DEVICE_Width-32, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:adContentLabel.font}
                                                      context:nil].size;
    int adRow = (int)(adTextSize.height/17)-1;
    if (adRow<0) {
        adRow = 0;
    }
    float adContentLabelHeight = adTextSize.height+8*adRow;
    
    [adContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headerView).with.offset(16);
        make.top.equalTo(self->alignTopView.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, adContentLabelHeight));
    }];
    contentSizeHeight += 20+adContentLabelHeight;
    
    contentSizeHeight += 20;
    
    headerView.height = contentSizeHeight;
    
    [self.tableView reloadData];
    
    ///
    UIView *viewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, DEVICE_Width, 50)];
    [self.view addSubview:viewbottom];
    [self drawbottomView:viewbottom];
    
}
///底部绘制
-(void)drawbottomView:(UIView *)view
{
    UIButton *btpinglun = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, view.height)];
    [btpinglun setTitle:NSLocalizedString(@"comments", nil) forState:UIControlStateNormal];
    [btpinglun setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    [btpinglun.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btpinglun setImage:[UIImage imageNamed:@"ic_order_n"] forState:UIControlStateNormal];
    [btpinglun layoutButtonWithEdgeInsetsStyle:GHButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [btpinglun addTarget:self action:@selector(pinLunAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btpinglun];
    
    UIButton *btcollect = [[UIButton alloc] initWithFrame:CGRectMake(view.width-80, 5, 70, 40)];
    [btcollect setBackgroundColor:RGB(30, 30, 240)];
    [btcollect setTitle:NSLocalizedString(@"collection", nil) forState:UIControlStateNormal];
    if(strcollect.intValue == 1)
    {
        [btcollect setTitle:NSLocalizedString(@"collectionCancle", nil) forState:UIControlStateNormal];
    }
    [btcollect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btcollect.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btcollect.layer setCornerRadius:3];
    [btcollect addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btcollect];
    _btcollect = btcollect;
    
    UIButton *btphone = [[UIButton alloc] initWithFrame:CGRectMake(btcollect.left-80, btcollect.top, btcollect.width, btcollect.height)];
    [btphone setBackgroundColor:RGB(30, 30, 240)];
    [btphone setTitle:NSLocalizedString(@"callUp", nil) forState:UIControlStateNormal];
    [btphone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btphone.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btphone.layer setCornerRadius:3];
    [btphone addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btphone];
    
}

- (void)addImageView:(NSString*)urlStr withTag:(NSUInteger)index{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [imageView addGestureRecognizer:tapGesture];
    imageView.tag = index;
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headerView).with.offset(16);
        make.top.equalTo(self->alignTopView.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 1));
    }];
    
    contentSizeHeight += 20;
    
    alignTopView = imageView;
    
    //根据图片比例更改imageView高度
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) {
                
                float imageViewheight = image.size.height/image.size.width*(DEVICE_Width-32);
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, imageViewheight));
                }];
                
                self->contentSizeHeight += imageViewheight;
                self->headerView.height = self->contentSizeHeight;
                [self.tableView reloadData];
            }
            
        });
        
    }];
    
}

- (void)addContactView:(NSString*)text withAlignTop:(float)top withSuperView:(UIView*)superView {
    
    UILabel *contactLabel = [[UILabel alloc]init];
    contactLabel.text = text;
    contactLabel.font = [UIFont systemFontOfSize:15];
    contactLabel.textColor = COL1;
    contactLabel.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).with.offset(16);
        make.top.equalTo(superView).with.offset(top);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width-32, 15));
    }];
    NSMutableAttributedString *phoneAttrString = [[NSMutableAttributedString alloc] initWithString:text];
    [phoneAttrString addAttribute:NSForegroundColorAttributeName
                            value:ORANGEREDCOLOR
                            range:NSMakeRange(0, 3)];
    contactLabel.attributedText = phoneAttrString;
    
    ////NSLocalizedString(@"callUp", nil)
//    if ([text rangeOfString: @"电话"].location != NSNotFound) {
        UIButton *callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callPhoneBtn setImage:[UIImage imageNamed:@"login_icon_cell"] forState:UIControlStateNormal];
        [callPhoneBtn addTarget:self action:@selector(callPhoneBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:callPhoneBtn];
        [callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView).with.offset(-40);
            make.top.equalTo(superView).with.offset(top-(30-15)/2.0f);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
//    }
}
#pragma mark - 图片点击
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    
    UIView *v = [self.view viewWithTag:222];
    if (v) {
        [v removeFromSuperview];
    }
    
    v = tapGesture.view;
    ShowImagesController *imageVC = [[ShowImagesController alloc] init];
    imageVC.imageArray = photoArr;
    imageVC.imageNameArray = [photoArr mutableCopy];
    imageVC.selectedIndex = v.tag;
    imageVC.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:imageVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *v = [self.view viewWithTag:222];
    if (v) {
        [v removeFromSuperview];
    }
}
#pragma mark - 拨打电话
- (void)callPhoneBtnOnTouch:(id)sender {
    
    UIView *v = [self.view viewWithTag:222];
    if (v) {
        [v removeFromSuperview];
    }
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", modeldetail.mobile];
    /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    });
    
}

#pragma mark - 评论点击
-(void)pinLunAction
{
    
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    FESendCommentView *sendCommentView = [FESendCommentView sharedView:NSLocalizedString(@"pleaseComment", nil)];
    sendCommentView.delegate = self;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:sendCommentView];
    [sendCommentView show];
    
}

#pragma mark - tableView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self->cellOtherActionView setHeight:0];
    } completion:^(BOOL finished) {
        [self->cellOtherActionView removeFromSuperview];
        self->cellOtherActionView = nil;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommentFloorIdentifier = @"CommentFloorHostCell";
    CommentFloorHostCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentFloorIdentifier];
    
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:CommentFloorIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CommentFloorIdentifier];
        cell = (CommentFloorHostCell *)[tableView dequeueReusableCellWithIdentifier:CommentFloorIdentifier];
    }
    HomeDetailContentModel *model = commentArr[indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfoavatar] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
    cell.nickNameLabel.text = model.userinfonickname;
    cell.model = commentArr[indexPath.row];
    cell.delegate = self;
    [cell.replyBtn setHidden:NO];
    if([model.userinfoid isEqualToString:[User sharedUser].user_id])
    {
        [cell.replyBtn setHidden:YES];
    }
    [cell countCellHeight:model.content andotherColrRange:NSMakeRange(0, 0)];
    
    if(model.ishuifu)
    {
        [cell countCellHeight:[NSString stringWithFormat:@"%@%@：%@",NSLocalizedString(@"huifu", nil),model.tousernickname, model.content] andotherColrRange:NSMakeRange(2, model.tousernickname.length)];
    }
    
    cell.dateTimeLabel.text = model.create_date;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 50)];
    [headView setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, DEVICE_Width, 40)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:bgView];
    
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, DEVICE_Width-32, 40)];
    sectionTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    sectionTitleLabel.textColor = COL1;
    sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
    sectionTitleLabel.text = NSLocalizedString(@"comments", nil);
    [bgView addSubview:sectionTitleLabel];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

/**
 *  分割线的处理
 */
- (void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}

#pragma mark - MDBwebDelegate
-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView
{
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
    
    contentSizeHeight+=h;
    headerView.height = contentSizeHeight;
    
    [self.tableView reloadData];
    
}


#pragma mark --评论相关

- (void)loadFirstData {
    
    self.page = 1;
    [self getpinglunData];
}

- (void)loadMoreData {
    self.page += 1;
    [self getpinglunData];
    
}
#pragma mark - 获取评论列表
-(void)getpinglunData
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"cms" forKey:@"name"];
    [dicpush setObject:_contentId forKey:@"key"];
    [dicpush setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [datacontrol contentData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        [self endHeaderRefreshing];
        [self endFooterRefreshing];
        if(self.page == 1)
        {
            self->commentArr = [NSMutableArray new];
        }
       if(state)
       {
           for(NSDictionary *dic in self->datacontrol.arrcontent)
           {
               HomeDetailContentModel *model = [HomeDetailContentModel dicToModelValue:dic];
               
               [self->commentArr addObject:model];
               
           }
       }
        [self.tableView reloadData];
    }];
    
}


#pragma mark - ///回复
-(void)huiFuSelectActionModel:(id)value
{
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    HomeDetailContentModel *model = value;
    FESendCommentView *sendCommentView = [FESendCommentView sharedView:NSLocalizedString(@"pleaseComment", nil)];
    sendCommentView.delegate = self;
    sendCommentView.strhuiid = model.did;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:sendCommentView];
    [sendCommentView show];
    
    
}
///其他点击
-(void)otehrSelectActionModel:(id)value andbutton:(UIButton *)sender
{
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    
    if(cellOtherActionView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self->cellOtherActionView setHeight:0];
        } completion:^(BOOL finished) {
            [self->cellOtherActionView removeFromSuperview];
            self->cellOtherActionView = nil;
        }];
        
        return;
    }
    HomeDetailContentModel *model = value;
    CGRect rect = [sender.superview convertRect:sender.frame toView:self.view.window];
    
    cellOtherActionView = [[MyOrderCellOtherActionView alloc] initWithFrame:CGRectMake(DEVICE_Width-70,rect.origin.y+25, 60, 65)];
    cellOtherActionView.model = model;
    [cellOtherActionView setDelegate:self];
    [self.view.window addSubview:cellOtherActionView];
    
    
}
#pragma mark - 删除评论
-(void)orderCellOtherActionItem:(id)model
{
    HomeDetailContentModel *models = model;
    ///删除评论
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [dicpush setObject:@"cms" forKey:@"name"];
    [dicpush setObject:_contentId forKey:@"key"];
    [datacontrol delCommentActionData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(self)
        {
            [self->commentArr removeObject:models];
            [self.tableView reloadData];
        }
        else
        {
             [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
    
}

///发布评论
-(void)pinglunSendActionView:(NSString *)value andhuifuid:(NSString *)strhuiid
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].user_id forKey:@"user_id"];
    [dicpush setObject:@"cms" forKey:@"name"];
    [dicpush setObject:_contentId forKey:@"key"];
    [dicpush setObject:value forKey:@"content"];
    if(strhuiid.length>0)
    {
        [dicpush setObject:[NSString nullToString:strhuiid] forKey:@"pid"];
    }
    [dicpush setObject:[Util getIPAddress:YES] forKey:@"ip"];
    
    [datacontrol pushcontentData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
        if(state)
        {
            [self loadFirstData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:desc];
        }
    }];
    
    
}
#pragma mark - 收藏 取消
-(void)collectAction
{
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    [_btcollect setUserInteractionEnabled:NO];
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[User sharedUser].token forKey:@"token"];
    [dicpush setObject:_contentId forKey:@"articleid"];
    
    if(strcollect.intValue == 1)
    {///取消收藏
        [datacontrol collectCancleActionData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
            [self->_btcollect setUserInteractionEnabled:YES];
            if(state)
            {
                self->strcollect = @"0";
                [self->_btcollect setTitle:NSLocalizedString(@"collection", nil) forState:UIControlStateNormal];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:desc];
            }
        }];
        
    }
    else
    {
        [datacontrol collectActionData:dicpush andshowView:self.view Callback:^(NSError *eroor, BOOL state, NSString *desc) {
            [self->_btcollect setUserInteractionEnabled:YES];
            if(state)
            {
                
                 [self->_btcollect setTitle:NSLocalizedString(@"collectionCancle", nil) forState:UIControlStateNormal];
                self->strcollect = @"1";
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:desc];
            }
        }];
        
    }
    
}
#pragma mark - 拨打电话
-(void)phoneAction
{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", modeldetail.mobile];
    /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    });
    
}

@end
