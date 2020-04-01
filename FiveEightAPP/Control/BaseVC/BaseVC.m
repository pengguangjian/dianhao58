//
//  BaseVC.m
//  GuoHuiAPP
//
//  Created by caochun on 16/8/29.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import "BaseVC.h"


@implementation BaseVC


-(void)loadView
{
    [super loadView];
    
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight) style:UITableViewStyleGrouped];
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstData)];
//    
//    // 设置正在刷新状态的动画图片
//    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//    
//    self.tableView.mj_header = header;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.mj_footer.automaticallyHidden = YES;/** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏。默认是NO） */
    
//    // 设置页面的颜色
//    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
//    //点击事件改变模式
//    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
//        // 切换为白天模式
//        [self.dk_manager dawnComing];
//    } else {
//        // 切换为夜间模式
//        [self.dk_manager nightFalling];
//    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    
#ifndef DEBUG
    if (_mPageName) {
        [MTA trackPageViewBegin:_mPageName];
    }
#endif
    
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (self.title) {
        _mPageName = self.title;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
#ifndef DEBUG
    if (_mPageName) {
        [MTA trackPageViewEnd:_mPageName];
    }
#endif
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
}

- (void)initWithRefreshTableView:(CGRect)rect
{
    self.tableView.frame = rect;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(248, 248, 248);
    self.tableView.separatorColor = SEPARATORCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
    
}

- (void)setNavigationBarTitle:(NSString*)title leftImage:(UIImage*)leftImage andRightImage:(UIImage*)rightImage
{
    UIView *separatorLine = [self.navigationController.navigationBar viewWithTag:100];
    if (!separatorLine) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-0.5, self.navigationController.navigationBar.frame.size.width, 0.5)];
        separatorLine.backgroundColor = SEPARATORCOLOR;
        separatorLine.tag = 100;
        [self.navigationController.navigationBar insertSubview:separatorLine atIndex:0];
    }
    
//    [self.navigationController.navigationBar bringSubviewToFront:separatorLine];
    
    if (title || leftImage || rightImage) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];//背景色
        
        // 设置导航默认标题的颜色及字体大小
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: COL1,
            UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
        
    }
    
    if (title) {
        [self setTitle:title];
    }
    
    CGFloat offset = 0;
    if (leftImage) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 40);
//        [leftButton setBackgroundColor:[UIColor blackColor]];
        if (@available(iOS 11.0, *)) {
            leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
            leftButton.translatesAutoresizingMaskIntoConstraints = false;
        }
        [leftButton addTarget:self action:@selector(leftBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:leftImage forState:UIControlStateNormal];
        [leftButton setImage:leftImage forState:UIControlStateHighlighted];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -15-8;

        self.navigationItem.leftBarButtonItems =  @[negativeSpacer, leftItem];
        
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnOnTouch:) image:leftImage];
       
    }
    
    if (rightImage) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 40, 40);
//        [rightBtn setBackgroundColor:[UIColor blackColor]];
        if (@available(iOS 11.0, *)) {
            rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
            rightBtn.translatesAutoresizingMaskIntoConstraints = false;
        }
        [rightBtn addTarget:self action:@selector(rightBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
//        [rightBtn setBackgroundColor:[UIColor blackColor]];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -15-8;
        
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
        
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnOnTouch:) image:rightImage];
    }
}


- (void)leftBtnOnTouch:(id)sender {
    
}

- (void)rightBtnOnTouch:(id)sender {
    
}

-(void)loadFirstData {
    
}

-(void)loadMoreData {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}



- (void)endHeaderRefreshing
{
    [self.tableView.mj_header endRefreshing];
}

- (void)endFooterRefreshing{
    [self.tableView.mj_footer endRefreshing];
}

- (void)endFooterRefreshingWithNoMoreData
{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    [self.tableView.mj_footer resetNoMoreData];
}


#pragma mark - 右滑返回的处理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count == 1) {//关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
    
}



@end
