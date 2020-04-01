//
//  YDDatePickerView.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "YDDatePickerView.h"

#define ToolbarHeight 44 //toobar高度

@interface YDDatePickerView()
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *cover;//蒙版
@property (nonatomic, strong) UIDatePicker *datePic;
@property (nonatomic, assign) NSInteger pickeviewHeight;//pickerview高度
@end

@implementation YDDatePickerView

- (instancetype)initWithDate:(NSDate *)date{
    self = [super init];
    if(self){
        [self setUpToolBar];
        
    }
    [self setUpDatePicker:date];
    return self;
}

- (void)setUpToolBar {
    _toolbar = [self setToolbarStyle];
    _toolbar.barTintColor = [UIColor whiteColor];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}

- (void)setUpDatePicker:(NSDate*)date {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePic = datePicker;
    datePicker.backgroundColor = COL8;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *minDate = [dateFormatter dateFromString:@"1950-01-01 00:00:00"];
    datePicker.minimumDate = minDate;
    
    

    if (date) {
        [datePicker setDate:date];
    }
    datePicker.frame = CGRectMake(0,ToolbarHeight, DEVICE_Width, datePicker.frame.size.height);
    _pickeviewHeight = datePicker.frame.size.height;
    [self addSubview:datePicker];
}

#pragma mark 设置toolbarStyle
- (UIToolbar *)setToolbarStyle {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[self customBtnName:NSLocalizedString(@"cancel", nil) action:@selector(hide)]];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *midItem = [[UIBarButtonItem alloc] initWithCustomView:[self customBtnName:@"When Was It?" action:nil]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[self customBtnName:NSLocalizedString(@"queding", nil) action:@selector(done)]];
//    toolbar.items = @[leftItem, space,midItem,space, rightItem];
    toolbar.items = @[leftItem, space,space, rightItem];
    return toolbar;
}


- (void)done
{
    [self hide];
    //
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedDate:)]){
        [self.delegate selectedDate:self.datePic.date];
    }
}
- (UIButton *)customBtnName:(NSString *)name action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 35);
    if([name isEqualToString:@"When Was It?"]){
        btn.frame = CGRectMake(0, 0, 200, 35);
    }
    [btn setTitle:name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    if([name isEqualToString:@"When Was It?"]){
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:COL1 forState:UIControlStateNormal];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)hide {
    CGRect oldFrame = self.frame;
    oldFrame.origin.y += self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = oldFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self removeCover];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
}
- (void)show {
    [self addCover];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGRect oldFrame = self.frame;
    oldFrame.origin.y -= DEVICE_Height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = oldFrame;
    }];
}
- (void)addCover {
    UIView *cover = [[UIView alloc] init];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heitht = [UIScreen mainScreen].bounds.size.height - y;
    cover.frame = CGRectMake(x, y, width, heitht);
    cover.backgroundColor = RGBA(102, 102, 102, 0.5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [cover addGestureRecognizer:tap];
    _cover = cover;
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    self.frame = CGRectMake(0, DEVICE_Height - (ToolbarHeight + self.pickeviewHeight) + DEVICE_Height, DEVICE_Width,ToolbarHeight + self.pickeviewHeight);
}
- (void)removeCover {
    if (_cover != nil) {
        [_cover removeFromSuperview];
        _cover = nil;
    }
}
#pragma mark 设置toolbar frame
-(void)setToolbarWithPickViewFrame {
    _toolbar.frame = CGRectMake(0, 0, DEVICE_Width, ToolbarHeight);
}

@end
