//
//  XSZStretchableTableHeaderView.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/4/26.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XSZStretchableTableHeaderView : NSObject

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* view;

/**
 <#Description#>

 @param tableView
 @param view 拉伸的背景图片
 @param subview 内容部分
 */
- (void)stretchHeaderForTableView:(UITableView*)tableView
                         withView:(UIView*)view
                         subViews:(UIView*)subview;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

- (void)resizeView;

@end

/*
 *使用时要实现以下两个代理方法
 *- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *- (void)viewDidLayoutSubviews
 */
