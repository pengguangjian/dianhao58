//
//  BaseVC.h
//  GuoHuiAPP
//
//  Created by caochun on 16/8/29.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPKeyboardAvoidingTableView.h"


@interface BaseVC : UIViewController

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong)  TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong)  NSString *mPageName;//统计页面名称
@property (nonatomic, assign) int page;//分页加载，页码


/**
 *  创建导航栏
 *
 *  @param title      标题
 *  @param leftImage  左边按钮图片
 *  @param rightImage 右边按钮图片
 */
- (void)setNavigationBarTitle:(NSString*)title leftImage:(UIImage*)leftImage andRightImage:(UIImage*)rightImage;

/**
 *  创建TableView
 *
 *  @param rect Frame
 */
- (void)initWithRefreshTableView:(CGRect)rect;

/**
 *  MJRefresh 方法封装
 */
- (void)endHeaderRefreshing;//结束刷新动画
- (void)endFooterRefreshing;
- (void)endFooterRefreshingWithNoMoreData;//结束动画并设置为没有更多数据
- (void)resetNoMoreData;//普通闲置状态

@end
