//
//  FEClassifyCollectionView.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "FEClassifyCollectionView.h"
#import "FEClassifyCollectionViewCell.h"

@interface FEClassifyCollectionView ()
@property (nonatomic, strong) UICollectionView *collectionView;
@end;

@implementation FEClassifyCollectionView

#pragma mark -- Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialization];
    }
    return self;
}

- (void)initialization {
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //左右间距
    flowlayout.minimumInteritemSpacing = 0;
    //上下间距
    flowlayout.minimumLineSpacing = 16;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowlayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"FEClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FEClassifyCollectionViewCell"];
    [self addSubview:_collectionView];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    
    if (![_dataArr isEqualToArray:dataArr] ||
        _dataArr != dataArr) {
        
        _dataArr = [dataArr copy];
        
        int row = _dataArr.count/4;
        if (_dataArr.count%4>0) {
            row++;
        }
        
        self.height = row*(16+(DEVICE_Width - 16*4) / 4.0*(9.0/16.0))+16;
        _collectionView.height = self.height;
        
        [self.collectionView reloadData];
    }
    
    
}


#pragma mark - UICollectionView DataSource Delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FEClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEClassifyCollectionViewCell" forIndexPath:indexPath];
    
    NSString *text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.classifyLabel.text = text;
//    if ((indexPath.row+1) % 7 != 0) {
//        cell.redView.hidden = YES;
//    }
//
//    if ((indexPath.row+1) % 10 == 0) {
//        cell.classifyLabel.textColor = REDCOLOR;
//    } else {
//        cell.classifyLabel.textColor = COL1;
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    selectedIndexPath = indexPath;
    //    selectedDayIndex = currentDayIndex;
    //    [self.subTimeCollectionView reloadData];
    //
    [self.delegate selectItemValue:_dataArr[indexPath.row]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVICE_Width - 16*4) / 4.0,
                      (DEVICE_Width - 16*4) / 4.0*(9.0/16.0));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16, 16, 16, 16);
}


@end
