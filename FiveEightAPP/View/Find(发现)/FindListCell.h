//
//  FindListCell.h
//  FiveEightAPP
//
//  Created by Cc on 2019/12/9.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@end

NS_ASSUME_NONNULL_END
