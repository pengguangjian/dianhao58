//
//  MyOrderCellOtherActionView.m
//  Meidebi
//
//  Created by mdb-losaic on 2020/2/11.
//  Copyright © 2020 penggj. All rights reserved.
//

#import "MyOrderCellOtherActionView.h"

@implementation MyOrderCellOtherActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        [self setBackgroundColor:RGBA(0, 0, 0, 0.01)];
        
        UIImageView *imgvsj = [[UIImageView alloc] init];
        [imgvsj setBackgroundColor:[UIColor clearColor]];
//        imgvsj.layer.shadowOffset = CGSizeMake(0, -2);
//        imgvsj.layer.shadowOpacity = 0.1;
//        imgvsj.layer.shadowRadius = 2;
//        imgvsj.layer.shadowColor = RGB(0, 0, 0).CGColor;
        [self addSubview:imgvsj];
        [imgvsj setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *imgsj = [UIImage imageNamed:@"orderOtherActionsanjiao"];
        [imgvsj setImage:imgsj];
        [imgvsj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.offset(11);
            make.right.equalTo(self).offset(-15);
            make.width.offset(imgsj.size.width*11/imgsj.size.height);
        }];
        
        
        UIView *viewinfo = [[UIView alloc] init];
        [viewinfo setBackgroundColor:[UIColor whiteColor]];
        viewinfo.layer.masksToBounds = false;
        viewinfo.layer.shadowOffset = CGSizeMake(0, 0);
        viewinfo.layer.shadowOpacity = 0.2;
        viewinfo.layer.shadowRadius = 3;
        viewinfo.layer.shadowColor = RGB(0, 0, 0).CGColor;
        [viewinfo.layer setCornerRadius:2];
        [self addSubview:viewinfo];
        [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(imgvsj.mas_bottom).offset(-2);
        }];
        
        NSArray *arrbt = @[NSLocalizedString(@"deleteComments", nil)];
        UIButton *btlast;
        for(int i = 0 ; i < arrbt.count; i++)
        {
            UIButton *btitem = [[UIButton alloc] init];
            [btitem setTitle:arrbt[i] forState:UIControlStateNormal];
            [btitem setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
            [btitem.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btitem setTag:i];
            [btitem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            [viewinfo addSubview:btitem];
            [btitem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(viewinfo);
                make.height.offset(35);
                make.top.offset(35*i);
            }];
            
            if(i<arrbt.count-1)
            {
                UIView *viewline = [[UIView alloc] init];
                [viewline setBackgroundColor:RGB(245, 245, 245)];
                [viewinfo addSubview:viewline];
                [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(btitem);
                    make.height.offset(1);
                    make.top.equalTo(btitem.mas_bottom);
                }];
            }
            btlast = btitem;
            
        }
        
        [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btlast);
        }];
        
    }
    return self;
}


-(void)itemAction:(UIButton *)sender
{
    if(self.delegate)
    {
        [self.delegate orderCellOtherActionItem:self.model];
    }
    
    
    
    
    [self removeFromSuperview];
    
    
}

@end
