//
//  FESeletTypeView.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/30.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "FESeletTypeView.h"
#import "ColumnTypeObj.h"

@interface FESeletTypeView() <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *bgView;
    float bgViewHeight;
    
    UIPickerView *pickView;
    NSInteger pick1;
    
    NSArray *dataArr;
}

@end

@implementation FESeletTypeView

+ (instancetype)sharedView:(NSArray*)arr {
    
    static dispatch_once_t once;
    static FESeletTypeView *seletTypeView;
    dispatch_once(&once, ^ {
        seletTypeView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        
        [seletTypeView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        
    });
    
    [seletTypeView removeAllView];
    [seletTypeView initView:arr];
    
    return seletTypeView;
    
}

- (void)removeAllView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

/**
 *  绘制界面
 */
- (void)initView:(NSArray*)arr
{
    
    dataArr = arr;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    //    [self addGestureRecognizer:tapGesture];
    
    
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(DEVICE_Height);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 250));
    }];
    
    bgViewHeight = 250;
    
    //    UIView *midLine = [[UIView alloc]init];
    //    midLine.backgroundColor = RGB(218, 218, 218);
    //    [bgView addSubview:midLine];
    //    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(bgView);
    //        make.top.equalTo(bgView).with.offset(16);
    //        make.size.mas_equalTo(CGSizeMake(1, 18));
    //    }];
    
    //    UIView *lineView = [[UIView alloc]init];
    //    lineView.backgroundColor = RGB(218, 218, 218);
    //    [bgView addSubview:lineView];
    //    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(bgView).with.offset(49);
    //        make.left.equalTo(bgView).with.offset(0);
    //        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 1));
    //    }];
    
    UIButton *closeAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeAddBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeAddBtn setTitleColor:COL2 forState:UIControlStateHighlighted];
    [closeAddBtn setTitleColor:COL1 forState:UIControlStateNormal];
    closeAddBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeAddBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeAddBtn];
    [closeAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(0);
        make.left.equalTo(bgView).with.offset(0);
        //        make.size.mas_equalTo(CGSizeMake(DEVICE_Width/2.0, 50));
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:COL1 forState:UIControlStateNormal];
    [ensureBtn setTitleColor:COL2 forState:UIControlStateHighlighted];
    ensureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [ensureBtn addTarget:self action:@selector(ensureBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:ensureBtn];
    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(0);
        make.right.equalTo(bgView).with.offset(0);
        //        make.size.mas_equalTo(CGSizeMake(DEVICE_Width/2.0, 50));
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    
    pickView = [[UIPickerView alloc]init];
    pickView.backgroundColor = COL8;
    pickView.delegate = self;
    pickView.dataSource = self;
    [bgView addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(50);
        make.left.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 200));
    }];
    
    [pickView reloadAllComponents];
    
    [pickView selectRow:0 inComponent:0 animated:NO];
    
    [self pickerView:pickView didSelectRow:0 inComponent:0];
}


- (void)ensureBtnOnTouch:(id)sender
{
    
    pick1 = [pickView selectedRowInComponent:0];
    
    id type = [dataArr objectAtIndex:pick1];
    
    if (self.handler) {
        self.handler(type);
    }
    
    [self hiddenView];
}


- (void)hiddenView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
        __block FESeletTypeView *weakSelf = self;
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf removeFromSuperview];
        });
        
    } completion:^(BOOL finished){
        
    }];
}


- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self hiddenView];
}

- (void)show{
    
    [UIView animateWithDuration:0.5 animations:^{
        bgView.layer.transform = CATransform3DMakeTranslation(0, -bgViewHeight, 0);
    } completion:^(BOOL finished){
        
    }];
    
}


#pragma mark - pickView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return dataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [dataArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    static NSInteger proRow = 0;
    if (component == 0)
    {
        proRow = row;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        //字体大小自适应
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    
    id type = [dataArr objectAtIndex:row];
    if ([type isKindOfClass:[ColumnTypeObj class]]) {
        ColumnTypeObj *cto = type;
        pickerLabel.text = cto.name;
    }
    
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

@end
