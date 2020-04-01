//
//  XSZStretchableTableHeaderView.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/4/26.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "XSZStretchableTableHeaderView.h"

@interface XSZStretchableTableHeaderView (){
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@end


@implementation XSZStretchableTableHeaderView

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view subViews:(UIView*)subview
{
    self.tableView = tableView;
    self.view      = view;
    
    initialFrame       = self.view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    
    self.tableView.tableHeaderView = emptyTableHeaderView;
    
    [self.tableView addSubview:self.view];
    [self.tableView addSubview:subview];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = self.view.frame;
    f.size.width = self.tableView.frame.size.width;
    self.view.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        initialFrame.origin.y = - offsetY * 1;
        initialFrame.origin.x = - offsetY / 2;
        
        initialFrame.size.width  = self.tableView.frame.size.width + offsetY;
        initialFrame.size.height = defaultViewHeight + offsetY;
        
        self.view.frame = initialFrame;
    }
    
}


- (void)resizeView
{
    initialFrame.size.width = self.tableView.frame.size.width;
    self.view.frame = initialFrame;
}

@end
