//
//  HomeSearchTableViewCell.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "HomeSearchTableViewCell.h"

@interface HomeSearchTableViewCell ()
{
    
    
}

@property (nonatomic,retain) UIImageView *imgvhead;
@property (nonatomic,retain) UIImageView *imgvrz;
@property (nonatomic,retain) UILabel *lbtitle;
@property (nonatomic,retain) UILabel *lbother;
@property (nonatomic,retain) UILabel *lbtime;
@property (nonatomic,retain) UILabel *lbaddress;
@property (nonatomic,retain) UILabel *lbviews;


@end

@implementation HomeSearchTableViewCell
@synthesize model;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        UIView *viewback = [[UIView alloc] init];
        [self.contentView addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imgvhead = [[UIImageView alloc] init];
        [imgvhead setBackgroundColor:[UIColor grayColor]];
        [viewback addSubview:imgvhead];
        [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(15);
            make.bottom.equalTo(viewback).offset(-15);
            make.width.equalTo(viewback.mas_height).offset(-30);
        }];
        _imgvhead = imgvhead;
        
        UIImageView *imgvrz = [[UIImageView alloc] init];
        [imgvhead addSubview:imgvrz];
        [imgvrz mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0);
            make.size.sizeOffset(CGSizeMake(30, 30));
        }];
        _imgvrz= imgvrz;
        
        UILabel *lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_right).offset(10);
            make.right.equalTo(viewback).offset(-10);
            make.top.equalTo(imgvhead);
        }];
        _lbtitle = lbtitle;
        
        UILabel *lbother = [[UILabel alloc] init];
        [lbother setTextColor:RGB(30, 30, 30)];
        [lbother setTextAlignment:NSTextAlignmentLeft];
        [lbother setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbother];
        [lbother mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.bottom.equalTo(imgvhead).offset(-5);
            make.width.offset(160);
            make.height.offset(20);
        }];
        _lbother= lbother;
        
        
        UILabel *lbaddress = [[UILabel alloc] init];
        [lbaddress setTextColor:RGB(30, 30, 30)];
        [lbaddress setTextAlignment:NSTextAlignmentLeft];
        [lbaddress setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbaddress];
        [lbaddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.bottom.equalTo(lbother.mas_top);
            make.right.equalTo(viewback.mas_right).offset(-150);
            make.height.offset(20);
        }];
        _lbaddress = lbaddress;
        
        
        
        UILabel *lbtime = [[UILabel alloc] init];
        [lbtime setTextColor:RGB(30, 30, 30)];
        [lbtime setTextAlignment:NSTextAlignmentRight];
        [lbtime setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbtime];
        [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbtitle);
            make.top.equalTo(lbaddress);
            make.left.equalTo(lbaddress.mas_right);
            make.height.offset(20);
        }];
        _lbtime = lbtime;
        
        UILabel *lbviews = [[UILabel alloc] init];
        [lbviews setTextColor:RGB(30, 30, 30)];
        [lbviews setTextAlignment:NSTextAlignmentRight];
        [lbviews setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbviews];
        [lbviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbtitle);
            make.top.equalTo(lbtime.mas_bottom);
            make.width.offset(160);
        }];
        _lbviews = lbviews;
        
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(240, 240, 240)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead);
            make.right.equalTo(lbtitle);
            make.bottom.equalTo(viewback);
            make.height.offset(1);
        }];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_imgvhead sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"img_my_head"]];
    
    [_lbtitle setText:model.title];
    
    [_lbother setText:[NSString stringWithFormat:@"%@-%@",model.parent_channel_name,model.channel_name]];
    
    [_lbtime setText:model.publishtime_text];
    
    
    if(model.city_name.length>0)
    {
        [_lbaddress setText:[NSString stringWithFormat:@"%@",model.city_name]];
        if(model.area_name.length>0)
        {
            [_lbaddress setText:[NSString stringWithFormat:@"%@-%@",model.city_name,model.area_name]];
        }
    }
    else
    {
        [_lbaddress setText:[NSString stringWithFormat:@"%@",model.area_name]];
    }
    
    [_lbviews setText:[NSString stringWithFormat:@"%d%@",model.views.intValue,NSLocalizedString(@"comments2", nil)]];
    
    [_imgvrz setImage:[UIImage imageNamed:@""]];
    if(model.authentication_status.intValue == 1)
    {
        [_imgvrz setImage:[UIImage imageNamed:@"gerenrenzhengSuccess"]];
    }
    else if(model.authentication_status.intValue == 2)
    {
        [_imgvrz setImage:[UIImage imageNamed:@"qiyerenzhengSuccess"]];
    }
    
}

@end
