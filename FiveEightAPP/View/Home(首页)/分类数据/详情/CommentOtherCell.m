//
//  CommentOtherCell.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "CommentOtherCell.h"

@implementation CommentOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nickNameLabel.textColor = COL1;
    self.contentLabel.textColor = COL1;
    self.dateTimeLabel.textColor = COL2;
    
    self.arguedView.backgroundColor = VIEWBGCOLOR;
    self.arguedContentLabel.textColor = COL2;
    self.arguedUserAndTimeLabel.textColor = COL2;
    
    [self.headImageView.layer setCornerRadius:15.0f];
}

- (void)countCellHeight:(NSString*)content
      withArguedContent:(NSString*)arguedContent {
    
    NSMutableParagraphStyle *arguedContentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为6
    [arguedContentParagraphStyle  setLineSpacing:6];
    NSMutableAttributedString  *arguedContentAttr = [[NSMutableAttributedString alloc] initWithString:arguedContent];
    [arguedContentAttr addAttribute:NSParagraphStyleAttributeName value:arguedContentParagraphStyle range:NSMakeRange(0, [arguedContent length])];
    self.arguedContentLabel.attributedText = arguedContentAttr;
    
    //计算高度
    CGSize arguedContentSize = [content boundingRectWithSize:CGSizeMake(DEVICE_Width-58-16-24, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:self.arguedContentLabel.font}
                                               context:nil].size;
    int arguedContentRow = (int)(arguedContentSize.height/14)-1;
    if (arguedContentRow<0) {
        arguedContentRow = 0;
    }
    float arguedContentHeight = arguedContentSize.height+6*arguedContentRow;
    self.arguedViewHeight.constant = 66-17+arguedContentHeight;
    
    
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为6
    [contentParagraphStyle  setLineSpacing:6];
    NSMutableAttributedString  *contentAttr = [[NSMutableAttributedString alloc] initWithString:content];
    [contentAttr addAttribute:NSParagraphStyleAttributeName value:contentParagraphStyle range:NSMakeRange(0, [content length])];
    self.contentLabel.attributedText = contentAttr;
    
    //计算高度
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(DEVICE_Width-58-16, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:self.contentLabel.font}
                                               context:nil].size;
    int contentRow = (int)(contentSize.height/15)-1;
    if (contentRow<0) {
        contentRow = 0;
    }
    float cellHeight = contentSize.height+6*contentRow;
    
    [self setHeight:155+cellHeight+(self.arguedViewHeight.constant-66)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
