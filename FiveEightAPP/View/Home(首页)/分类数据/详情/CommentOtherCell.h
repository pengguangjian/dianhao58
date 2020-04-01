//
//  CommentOtherCell.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentOtherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *headImageBtn;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIButton *zanBtn;
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arguedViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *arguedUserAndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *arguedContentLabel;
@property (strong, nonatomic) IBOutlet UIView *arguedView;

- (void)countCellHeight:(NSString*)content
      withArguedContent:(NSString*)arguedContent;

@end

NS_ASSUME_NONNULL_END
