//
//  ShowImagesController.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "ShowImagesController.h"
#import "ImageCollectionCell.h"
#import "JKAssets.h"

#define ALOGDebug(...) NSLog(__VA_ARGS__)

@interface ShowImagesController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
{
    // 导航条
    UIView              *_navigationBar;
    // 图片
    UICollectionView    *_photoView;
    // 标题
    UILabel             *_titleLabel;
}

@end

@implementation ShowImagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
}

// 添加试图
- (void)addSubViews {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, SafeAreaTopHeight)];
        _navigationBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_navigationBar];
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_Width-100)/2, SafeAreaTopHeight-44, 100, 44)];
            [_titleLabel setFont:[UIFont systemFontOfSize:15]];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_titleLabel setTextColor:[UIColor whiteColor]];
            [self.view addSubview:_titleLabel];
        }
        
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"ic_stat_back_02_n"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(10, SafeAreaTopHeight-44, 44, 43);
            } else {
                [btn setTitle:@"删除" forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(DEVICE_Width-50, SafeAreaTopHeight-44, 44, 43);
            }
            
            if (!_isShowDelBtn && i) {
                break;
            }
            
            [_navigationBar addSubview:btn];
        }
    }
    
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        _photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight) collectionViewLayout:layout];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        _photoView.backgroundColor = [UIColor blackColor];
        _photoView.opaque = NO;
        _photoView.pagingEnabled = YES;
        _photoView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_photoView];
        
        [_photoView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
    }
    
    [_photoView setContentOffset:CGPointMake(DEVICE_Width*self.selectedIndex, 0) animated:NO];
    
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld" ,self.selectedIndex+1 ,self.imageArray.count];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

// 返回
- (void)back:(UIButton *)sender {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPICTURES" object:self.imageArray];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 删除图片
- (void)deleteImage:(UIButton *)sender {
    // 删除缓存的图片
    NSInteger index = _photoView.contentOffset.x/DEVICE_Width;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"MSImage/"];
    if ([fm fileExistsAtPath:filePath]) {
        NSString *filname = self.imageNameArray[index];
        NSError *error = nil;
        BOOL res = [fm removeItemAtPath:[filePath stringByAppendingPathComponent:filname] error:&error];
        if (!res) {
            ALOGDebug(@"删除失败 error = %@", error);
        }
    }
    
    if (self.imageArray.count > 1) {
        [self.imageNameArray removeObjectAtIndex:index];
        [self.imageArray removeObjectAtIndex:index];
        [_photoView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger index1 = _photoView.contentOffset.x/DEVICE_Width;
            _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld" ,index1+1 ,self.imageArray.count];
        });
    }
    else {
        [self.imageArray removeAllObjects];
        [self back:nil];
    }
}

#pragma mark - ===================== UICollectionViewDataSource =====================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    id obj = [self.imageArray objectAtIndex:indexPath.item];
    if ([obj isKindOfClass:[UIImage class]]) {
        cell.imageView.image = obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    } else {
        JKAssets *asset = (JKAssets *)obj;
        cell.imageView.image = asset.photo;
    }
    [cell setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}

#pragma mark - ===================== UICollectionViewDelegate =====================

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALOGDebug(@"indexpath.row = %ld text = %@", indexPath.item, [self.imageArray objectAtIndex:indexPath.item]);
}

#pragma mark - ===================== UICollectionViewDelegateFlowLayout =====================

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(DEVICE_Width, DEVICE_Height-SafeAreaTopHeight);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/DEVICE_Width;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld" ,index+1 ,self.imageArray.count];
}


@end
