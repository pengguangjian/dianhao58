//
//  CommentFloorHostCell.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommentFloorHostCellDelegate <NSObject>

-(void)huiFuSelectActionModel:(id)value;
-(void)otehrSelectActionModel:(id)value andbutton:(UIButton *)sender;
@end

@interface CommentFloorHostCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *headImageBtn;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *zanBtn;
///回复
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@property (nonatomic , retain) id model;
@property (nonatomic,weak)id<CommentFloorHostCellDelegate>delegate;

- (void)countCellHeight:(NSString*)content andotherColrRange:(NSRange)range;
- (IBAction)otherAction:(id)sender;
- (IBAction)huifuAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
