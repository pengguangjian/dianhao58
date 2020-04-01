//
//  PublishTypeVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "PublishTypeVC.h"
#import "PublishTypeCell.h"
#import "PublishContentVC.h"
#import "HomeVC.h"
#import "HomeLanMuModel.h"

@interface PublishTypeVC ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArr;
@end

@implementation PublishTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _closeBtnAlignBottom.constant = 15+SafeAreaBottomHomeHeight;
    _closeBtn.transform = CGAffineTransformMakeRotation(M_PI_4*3);
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:YES];
}

- (void)initView {
    
    UILabel *shortcutPublishLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, SafeAreaTopHeight - 24, DEVICE_Width-32, 18)];
    shortcutPublishLabel.font = [UIFont boldSystemFontOfSize:18];
    shortcutPublishLabel.text = NSLocalizedString(@"kuaijiefabu", nil);
    shortcutPublishLabel.textColor = COL1;
    shortcutPublishLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:shortcutPublishLabel];
    
    UITabBarController *tabBarCtrl = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UINavigationController *navi = [tabBarCtrl.viewControllers objectAtIndex:0];
    HomeVC *homeVC = [navi.viewControllers firstObject];
    
    
    _dataArr = homeVC.typeArr;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //左右间距
    flowlayout.minimumInteritemSpacing = 0;
    //上下间距
    flowlayout.minimumLineSpacing = 16;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight - 24+18, DEVICE_Width, 350) collectionViewLayout:flowlayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"PublishTypeCell" bundle:nil] forCellWithReuseIdentifier:@"PublishTypeCell"];
    [self.view addSubview:_collectionView];
    
}


- (IBAction)closeBtnOnTouch:(id)sender {
    
    //返回
    UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [tabBar setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishTypeCell" forIndexPath:indexPath];
    
    HomeLanMuModel *cto = [_dataArr objectAtIndex:indexPath.row];
    
    cell.typeTitleLabel.text = cto.name;
    [cell.typeImageView sd_setImageWithURL:[NSURL URLWithString:cto.image] placeholderImage:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    selectedIndexPath = indexPath;
    //    selectedDayIndex = currentDayIndex;
    //    [self.subTimeCollectionView reloadData];
    //
    
    if ([User isNeedLogin]) {
        [Util LoginVC:YES];
        return;
    }
    
    HomeLanMuModel *cto = [_dataArr objectAtIndex:indexPath.row];
    
    PublishContentVC *vc = [[PublishContentVC alloc] initWithNibName:@"PublishContentVC" bundle:nil];
    vc.cto = cto;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVICE_Width - 16*4) / 4.0,70);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16, 16, 16, 16);
}

@end
