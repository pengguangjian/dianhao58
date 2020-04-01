//
//  SelectCityView.m
//  GuoHuiAPP
//
//  Created by caochun on 2016/10/30.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import "SelectCityView.h"

#import "UIView+Size.h"
#import "Masonry.h"

@interface SelectCityView ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *bgView;
    float bgViewHeight;
    
    UIPickerView *pickView;
    NSString *proStr;
    NSString *cityStr;
    NSString *areaStr;
    
    NSInteger pick1;
    NSInteger pick2;
    NSInteger pick3;
    
    NSArray *cityRecord;
    NSArray *areaRecord;
    
    NSArray *city_idRecord;
    NSArray *area_idRecord;
}
@end


@implementation SelectCityView

+ (instancetype)sharedView {
    
    static dispatch_once_t once;
    static SelectCityView *selectCityView;
    dispatch_once(&once, ^ {
        selectCityView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        
        [selectCityView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        
    });
    
    [selectCityView removeAllView];
    [selectCityView initView];
    
    return selectCityView;
    
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
- (void)initView
{
    
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
    
    if (!self.addString) {
        self.addString = @"北京市东城区";
        
    } else {
        self.addString = @"北京市东城区";
    }
    
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
    [pickView selectRow:0 inComponent:1 animated:NO];
    [pickView selectRow:0 inComponent:2 animated:NO];
    
    [self pickerView:pickView didSelectRow:0 inComponent:0];
    [self pickerView:pickView didSelectRow:0 inComponent:1];
    [self pickerView:pickView didSelectRow:0 inComponent:2];
}


- (void)ensureBtnOnTouch:(id)sender
{
    
    if (!self.lastAdd)
    {
        self.lastAdd = @"省市";
    }
    if (!self.addString)
    {
        self.addString = @"北京市东城区";
    }
    self.lastAdd = self.addString;
    pick1 = [pickView selectedRowInComponent:0];
    pick2 = [pickView selectedRowInComponent:1];
    pick3 = [pickView selectedRowInComponent:2];
    
    self.lastAdd = self.addString;
    
    id pro_id = [self.pro_idArray objectAtIndex:pick1];
    id city_id = [self.city_idArray objectAtIndex:pick2];
    id area_id = [self.area_idArray objectAtIndex:pick3];
    
    if (self.selectCityHandler) {
        self.selectCityHandler(self.lastAdd, pro_id, city_id, area_id);
    }
    
    [self hiddenView];
    
}


- (void)hiddenView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);

        __block SelectCityView *weakSelf = self;
        
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
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provArray.count;
    }
    else if (component == 1)
    {
        return self.cityArray.count;
    }
    else
    {
        return self.areaArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0){
        return [self.provArray objectAtIndex:row];
    }
    else if(component == 1){
        return [self.cityArray objectAtIndex:row];
    }
    else{
        return [self.areaArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    static NSInteger proRow = 0;
    if (component == 0)
    {
        proRow = row;
        self.cityArray = [[[self.cityList objectAtIndex:row]valueForKey:@"c"]valueForKey:@"n"];
        self.city_idArray = [[[self.cityList objectAtIndex:row]valueForKey:@"c"]valueForKey:@"c_id"];//c_id
        self.area_idArray = [[[[[self.cityList objectAtIndex:row]valueForKey:@"c"]objectAtIndex:0]valueForKey:@"a"]valueForKey:@"s_id"];//s_id
        self.areaArray = [[[[[self.cityList objectAtIndex:row]valueForKey:@"c"]objectAtIndex:0]valueForKey:@"a"]valueForKey:@"s"];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if (component == 1)
    {
        self.areaArray = [[[[[self.cityList objectAtIndex:proRow]valueForKey:@"c"]objectAtIndex:row]valueForKey:@"a"]valueForKey:@"s"];
        self.area_idArray = [[[[[self.cityList objectAtIndex:proRow]valueForKey:@"c"]objectAtIndex:row]valueForKey:@"a"]valueForKey:@"s_id"];//s_id
        [pickerView reloadComponent:2];
        proStr = [self.provArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        cityStr = [self.cityArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        if ([cityStr isEqualToString:proStr])
        {
            self.addString = cityStr;
        }
        else
        {
            self.addString = [proStr stringByAppendingString:cityStr];
        }
        areaStr = [self.areaArray objectAtIndex:[pickerView selectedRowInComponent:2]];
        self.addString = [self.addString stringByAppendingString:areaStr];
    }
    else
    {
        proStr = [self.provArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        cityStr = [self.cityArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        if ([cityStr isEqualToString:proStr])
        {
            self.addString = cityStr;
        }
        else
        {
            self.addString = [proStr stringByAppendingString:cityStr];
        }
        areaStr = [self.areaArray objectAtIndex:[pickerView selectedRowInComponent:2]];
        self.addString = [self.addString stringByAppendingString:areaStr];
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
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (NSArray*)cityList
{
    if (!_cityList) {
        
        //读取Json文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
        _cityList = [dictionary valueForKey:@"citylist"];;
    }
    return _cityList;
}


- (NSArray*)provArray {
    
    if (!_provArray) {
        self.provArray = [self.cityList valueForKey:@"p"];
    }
    return _provArray;
}

- (NSArray*)cityArray {
    
    if (!_cityArray) {
        self.cityArray = [[[self.cityList objectAtIndex:0]valueForKey:@"c"]valueForKey:@"n"];
    }
    return _cityArray;
}

- (NSArray*)areaArray {
    
    if (!_areaArray) {
        self.areaArray = [[[[[self.cityList objectAtIndex:0]valueForKey:@"c"]objectAtIndex:0]valueForKey:@"a"]valueForKey:@"s"];
    }
    return _areaArray;
}

- (NSArray*)pro_idArray {
    
    if (!_pro_idArray) {
        self.pro_idArray = [self.cityList valueForKey:@"p_id"];//p_id
    }
    return _pro_idArray;
}

- (NSArray*)city_idArray {
    
    if (!_city_idArray) {
        self.city_idArray = [[[self.cityList objectAtIndex:0]valueForKey:@"c"]valueForKey:@"c_id"];//c_id
    }
    return _city_idArray;
}

- (NSArray*)area_idArray {
    
    if (!_area_idArray) {
        self.area_idArray =  [[[[[self.cityList objectAtIndex:0]valueForKey:@"c"]objectAtIndex:0]valueForKey:@"a"]valueForKey:@"s_id"];//s_id
    }
    return _area_idArray;
}


@end
