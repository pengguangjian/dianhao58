//
//  CCPActionSheetView.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cellDidSelectBlock)(NSString *indexString,NSInteger index);

typedef void(^closeAlertviewBlock)();

//动画样式
typedef enum viewAnimateDirection {
    ViewAnimateFromTop,
    ViewAnimateFromLeft,
    ViewAnimateFromRight,
    ViewAnimateFromBottom,
    ViewAnimateScale,
    ViewAnimateNone
} viewAnimateStyle;


@interface CCPActionSheetView : UIView

@property (nonatomic,copy)void(^cellDidSelectBlock)(NSString *indexString,NSInteger index);

@property (nonatomic,copy)void(^closeAlertviewBlock)();

@property (nonatomic,assign) viewAnimateStyle viewAnimateStyle;

@property (nonatomic,assign) BOOL isBGClose;

//微信样式底部弹窗
- (instancetype)initWithActionSheetArray:(NSArray *)indexTextArray;

- (void)cellDidSelectBlock:(cellDidSelectBlock) cellDidSelectBlock;

//自定义的弹窗视图
- (instancetype) initWithAlertView:(UIView *)alertView;

- (void) closeAlertView:(closeAlertviewBlock) closeAlertviewBlock;


@end
