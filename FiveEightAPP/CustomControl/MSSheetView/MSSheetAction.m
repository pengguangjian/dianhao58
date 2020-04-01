//
//  MSSheetAction.m
//  MeiShi
//
//  Created by caochun on 16/4/19.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSSheetAction.h"

#import "Masonry.h"

@interface MSSheetAction ()
{
    UIImageView *leftImage;
    UILabel *textLabel;
    UIImageView *rightImage;
}
@end

@implementation MSSheetAction


//+ (instancetype)sharedView {
//    
//    static dispatch_once_t once;
//    static MSSheetAction *sheetAction;
//    dispatch_once(&once, ^ {
//        sheetAction = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 49)];
//        [sheetAction setBackgroundColor:[UIColor whiteColor]];
//        [sheetAction initView];
//    });
//    return sheetAction;
//    
//}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, DEVICE_Width, 49);
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:RGB(222, 222, 222)];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 0.5));
    }];
    
    leftImage = [[UIImageView alloc] init];
    [self addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset((48-30)/2.0+0.25);
        make.left.equalTo(self).with.offset((DEVICE_Width-130-5)/2.0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    textLabel = [[UILabel alloc] init];
    textLabel.textColor = RGB(51, 51, 51);
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(13.75);
        make.left.equalTo(leftImage.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 21));
    }];
    
    rightImage = [[UIImageView alloc] init];
    [self addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(9.25);
        make.left.equalTo(textLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(btnOnTouck:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, 49));
    }];
    
    
}

- (void)btnOnTouck:(id)sender
{
    //self.superview 为MSSheetAction 的bgView , superView为MSSheetAction
    UIView *superView = self.superview.superview;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.superview.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
    } completion:^(BOOL finished){
        
        [superView removeFromSuperview];
        
    }];
    
    
    if (_btnClickBlock) {
        _btnClickBlock();
    }
}

- (void)initLeftImage:(UIImage*)lImage andContent:(NSString*)content andRightImage:(UIImage*)rImage
{
    leftImage.image = lImage;
    textLabel.text = content;
    rightImage.image = rImage;
    
    if (!rImage) {
        [leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).with.offset((DEVICE_Width-83-10)/2.0);
            
        }];
        
        
        [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftImage.mas_right).with.offset(10);
            
        }];
        
        if (content.length == 1) {
        
            
            [leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self).with.offset((DEVICE_Width-70)/2.0);
                
            }];
            [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(30, 21));
                
            }];
        }
    }
    
    if (!lImage && !rImage) {
        [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(150, 21));
            make.left.equalTo(self).with.offset((DEVICE_Width-150)/2.0);
            
        }];
        textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
}

- (void)setLImage:(UIImage *)lImage
{
    leftImage.image = lImage;
}

- (void)setContent:(NSString *)content
{
    textLabel.text = content;
}

- (void)setRImage:(UIImage *)rImage
{
    rightImage.image = rImage;
}

@end
