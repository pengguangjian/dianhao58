//
//  YDDatePickerView.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDDatePickerViewDelegate;

@interface YDDatePickerView : UIView

@property (nonatomic, strong) id<YDDatePickerViewDelegate> delegate;
- (instancetype)initWithDate:(NSDate*)date;
- (void)show;
@end

@protocol YDDatePickerViewDelegate <NSObject>

@optional
- (void)selectedDate:(NSDate*)date;

@end
