//
//  FESendCommentView.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "FESendCommentView.h"
#import "LPlaceholderTextView.h"

@interface FESendCommentView ()
{
    UIView *bgView;
    float bgViewHeight;
    
    NSString *placeholderStr;
    LPlaceholderTextView *textView;
    
}
@end

@implementation FESendCommentView

+ (instancetype)sharedView:(NSString*)placeholder {
    
    static dispatch_once_t once;
    static FESendCommentView *sendCommentView;
    dispatch_once(&once, ^ {
        sendCommentView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        
        [sendCommentView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        
    });
    
    [sendCommentView initView:placeholder];
    
    return sendCommentView;
    
}



- (void)initView:(NSString*)placeholder {
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    placeholderStr = placeholder;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    bgViewHeight = 150;
    
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(DEVICE_Height);
        make.size.mas_equalTo(CGSizeMake(DEVICE_Width, bgViewHeight));
    }];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:COL1 forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn.layer setMasksToBounds:YES];
    cancelBtn.xsz_acceptEventInterval = 1;
    [bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(0);
        make.left.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitleColor:ORANGEREDCOLOR forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(ensureBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [ensureBtn setTitle:NSLocalizedString(@"send", nil) forState:UIControlStateNormal];
    ensureBtn.xsz_acceptEventInterval = 1;
    [ensureBtn.layer setMasksToBounds:YES];
    
    [bgView addSubview:ensureBtn];
    
    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(0);
        make.right.equalTo(bgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    
    textView = [[LPlaceholderTextView alloc]init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholderText = placeholderStr;
    textView.placeholderColor = COL2;
    [textView becomeFirstResponder];
    textView.textColor = COL1;
    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = YES;
    textView.delegate = self;
    textView.textAlignment = NSTextAlignmentLeft;
    [textView.layer setCornerRadius:4.0f];
    [textView.layer setBorderColor:COL3.CGColor];
    [textView.layer setBorderWidth:1.0f];
    [bgView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancelBtn.mas_bottom).with.offset(0);
        make.left.equalTo(bgView).with.offset(6);
        make.right.equalTo(bgView).with.offset(-6);
        make.bottom.equalTo(bgView).with.offset(-6);
    }];
    
    [self addNoticeForKeyboard];
    
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)cancelBtnOnTouch:(id)sender
{
    [self dismisView];
}

- (void)ensureBtnOnTouch:(id)sender {
    [self.delegate pinglunSendActionView:textView.text andhuifuid:_strhuiid];
    [self dismisView];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self dismisView];
}

-(void)dismisView
{
    [UIView animateWithDuration:0.5 animations:^{
           
           
           [self->bgView mas_updateConstraints:^(MASConstraintMaker *make) {
               
               make.top.equalTo(self).with.offset(DEVICE_Height);
               
           }];
           
           __block FESendCommentView *weakSelf = self;
           
           
           dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
           dispatch_after(delayTime, dispatch_get_main_queue(), ^{
               [weakSelf removeFromSuperview];
           });
           
       } completion:^(BOOL finished){
           
       }];
}

- (void)show {
    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset((DEVICE_Height-bgViewHeight)/2.0);
//            
//        }];
//
//    } completion:^(BOOL finished){
//
//    }];
    
}


///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {

    /** 键盘完全弹出时间 */
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] intValue];
    
    /** 动画趋势 */
    int curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    /** 动画执行完毕frame */
    CGRect keyboard_frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    /** 获取键盘y值 */
    CGFloat keyboard_y = keyboard_frame.origin.y;
    
    /** view上平移的值 */
    CGFloat offset =  keyboard_y - bgViewHeight;
    
    /** 执行动画  */
    [UIView animateWithDuration:duration animations:^{
        
        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(offset);
        }];
    }];
    
}

//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
