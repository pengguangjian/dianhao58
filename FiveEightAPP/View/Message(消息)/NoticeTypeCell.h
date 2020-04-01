//
//  NoticeTypeCell.h
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BadgeView.h"

@interface NoticeTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *noticeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeViewContainerView;

//@property (strong, nonatomic) BadgeView *badgeView;

@end
