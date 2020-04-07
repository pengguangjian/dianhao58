//
//  XieYiAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/12/9.
//  Copyright © 2019 penggj. All rights reserved.
//

#import "XieYiAlterView.h"

#import "WebViewVC.h"

@interface XieYiAlterView ()<UITextViewDelegate>

@property (nonatomic , retain) NSString *strtitle;
@property (nonatomic , retain) NSString *strcontent;

@end

@implementation XieYiAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame andtitle:(NSString *)strtitle andcontent:(NSString *)strcontent
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGBA(0, 0, 0, 0.35)];
        _strtitle = strtitle;
        _strcontent = strcontent;
        if(strtitle == nil)
        {
            _strtitle = NSLocalizedString(@"wenxintishi", nil);
        }
        if(strcontent == nil)
        {
            _strcontent = NSLocalizedString(@"qinaideyonghutongyixieyitk", nil);
        }
        [self drawView];
        
        
    }
    return self;
}

-(void)drawView
{
    
    UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.width-40, 100)];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewback];
    [viewback.layer setMasksToBounds:YES];
    [viewback.layer setCornerRadius:5];
    
    UIScrollView *scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, viewback.width, 100)];
    [viewback addSubview:scvback];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, viewback.width-20, 30)];
    [lbtitle setNumberOfLines:0];
    [lbtitle setText:_strtitle];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setFont:[UIFont boldSystemFontOfSize:16]];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [scvback addSubview:lbtitle];
    
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:_strcontent];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 8;
    [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _strcontent.length)];
    
    
//    yingshizhengce
    @try {
        NSRange range = [_strcontent rangeOfString:NSLocalizedString(@"yingshizhengce", nil)];
        range.length = range.length+2;
        range.location = range.location-1;
        
        [noteStr addAttribute:NSLinkAttributeName value:@"yishixieyimainhome://" range:range];
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 20, 20) range:range];
    } @catch (NSException *exception) {
        [noteStr addAttribute:NSLinkAttributeName value:@"yishixieyimainhome://" range:NSMakeRange(0, _strcontent.length)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 20, 20) range:NSMakeRange(0, _strcontent.length)];
    } @finally {
        
    }
    
    
    UITextView *lbcontent = [[UITextView alloc] initWithFrame:CGRectMake(10, lbtitle.bottom+10, viewback.width-20, 30)];
    lbcontent.linkTextAttributes = @{};
    [lbcontent setText:_strcontent];
    [lbcontent setTextColor:RGB(130, 130, 130)];
    [lbcontent setFont:[UIFont systemFontOfSize:15]];
    [lbcontent setTextAlignment:NSTextAlignmentLeft];
    [lbcontent setAttributedText:noteStr];
    [lbcontent sizeToFit];
    [lbcontent setCenterX:viewback.width/2.0];
    [scvback addSubview:lbcontent];
    [lbcontent setEditable:NO];
    [lbcontent setScrollEnabled:NO];
    [lbcontent setDelegate:self];
    
    
    
    if(lbcontent.bottom>self.height*0.65)
    {
        [scvback setHeight:self.height*0.65];
        [scvback setContentSize:CGSizeMake(0, lbcontent.bottom+10)];
    }
    else
    {
        [scvback setHeight:lbcontent.bottom+10];
    }
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, scvback.bottom+10, viewback.width, 1)];
    [viewline setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline];
    
    
    UIButton *btfx = [[UIButton alloc] initWithFrame:CGRectMake(0, viewline.bottom, viewback.width*0.5, 50)];
    [btfx setTitle:NSLocalizedString(@"butongyi", nil) forState:UIControlStateNormal];
    [btfx setTitleColor:RGB(140, 140, 140) forState:UIControlStateNormal];
    [btfx.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [viewback addSubview:btfx];
    [btfx addTarget:self action:@selector(fenxiangAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(btfx.right, btfx.top, 1, btfx.height)];
    [viewline1 setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline1];
    
    UIButton *btcancle = [[UIButton alloc] initWithFrame:CGRectMake(viewline1.right, viewline.bottom, viewback.width-viewline1.right, btfx.height)];
    [btcancle setTitle:NSLocalizedString(@"tongyi", nil) forState:UIControlStateNormal];
    [btcancle setTitleColor:RGB(234, 58, 60) forState:UIControlStateNormal];
    [btcancle.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [viewback addSubview:btcancle];
    [btcancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    [viewback setHeight:btcancle.bottom];
    [viewback setCenter:CGPointMake(self.width/2.0, self.height/2.0)];
    
    
    
}

-(void)fenxiangAction
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"qingxiantongyiyishizhengce", nil)];
    
}
-(void)cancleAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"58tongyixieyi"];
    [self removeFromSuperview];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"yishixieyimainhome"]) {
        
        [self removeFromSuperview];
        ///跳转到隐私协议页面
        WebViewVC *vc = [[WebViewVC alloc] initLoadRequest:NSLocalizedString(@"yingshizhengce", nil) initWithTitle:@"frontend.page/merchant"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.nav pushViewController:vc animated:YES];
        
        return NO;
    }
    return YES;
}


@end
