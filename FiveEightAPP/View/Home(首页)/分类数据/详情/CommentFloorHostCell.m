//
//  CommentFloorHostCell.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "CommentFloorHostCell.h"

@implementation CommentFloorHostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nickNameLabel.textColor = COL1;
    self.contentLabel.textColor = COL1;
    
    self.dateTimeLabel.textColor = COL2;
    
    [self.headImageView.layer setCornerRadius:15.0f];
}

- (void)countCellHeight:(NSString*)content andotherColrRange:(NSRange)range{
    if(content==nil)
    {
        content = @"";
    }
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为6
    [contentParagraphStyle  setLineSpacing:6];
    NSMutableAttributedString  *contentAttr = [[NSMutableAttributedString alloc] initWithString:content];
    [contentAttr addAttribute:NSParagraphStyleAttributeName value:contentParagraphStyle range:NSMakeRange(0, [content length])];
    
    if(range.length>0)
    {
        [contentAttr addAttribute:NSForegroundColorAttributeName value:RGB(67, 170, 240) range:range];
    }
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
    float cellHeight = contentSize.height+6*contentRow+5;
    
    [self setHeight:85+cellHeight];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (IBAction)otherAction:(id)sender {
    
    [self.delegate otehrSelectActionModel:self.model andbutton:sender];
}

- (IBAction)huifuAction:(id)sender {
    [self.delegate huiFuSelectActionModel:self.model];
    
}
@end
