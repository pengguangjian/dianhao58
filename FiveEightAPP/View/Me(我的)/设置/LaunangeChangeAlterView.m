//
//  LaunangeChangeAlterView.m
//  FiveEightAPP
//
//  Created by Mac on 2020/4/1.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "LaunangeChangeAlterView.h"
#import "MSSheetView.h"

@interface LaunangeChangeAlterView ()
{
    
    MSSheetView *sheetView;
}
@end

@implementation LaunangeChangeAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedView {
    
    static dispatch_once_t once;
    static LaunangeChangeAlterView *selectSexView;
    dispatch_once(&once, ^ {
        selectSexView = [[self alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
        
        [selectSexView setBackgroundColor:RGBA(0, 0, 0, 0.5)];

        
    });
    
    [selectSexView initView];
    
    return selectSexView;
    
}


- (void)initView
{
    
    MSSheetAction *sheetAction = [[MSSheetAction alloc] init];
    [sheetAction initLeftImage:nil andContent:NSLocalizedString(@"Tiếng Việt", nil) andRightImage:nil];
    [sheetAction setBtnClickBlock:^(){
        
        if (self.selectLaunangeHandler) {
            
            self.selectLaunangeHandler(1);
            
        }
        
    }];
    
    
    MSSheetAction *sheetAction1 = [[MSSheetAction alloc] init];
    [sheetAction1 initLeftImage:nil andContent:NSLocalizedString(@"中文", nil) andRightImage:nil];
    [sheetAction1 setBtnClickBlock:^(){
        
        if (self.selectLaunangeHandler) {
            
            self.selectLaunangeHandler(2);
            
        }
        
    }];
    
//    MSSheetAction *sheetAction2 = [[MSSheetAction alloc] init];
//    [sheetAction2 initLeftImage:nil andContent:NSLocalizedString(@"English", nil) andRightImage:nil];
//    [sheetAction2 setBtnClickBlock:^(){
//        
//        if (self.selectLaunangeHandler) {
//            
//            self.selectLaunangeHandler(3);
//            
//        }
//        
//    }];
    
    sheetView = [MSSheetView sharedView];
    sheetView.title = NSLocalizedString(@"qiehuanyuyan", nil);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:sheetView];
    
    [sheetView addSheetAction:sheetAction];
    [sheetView addSheetAction:sheetAction1];
//    [sheetView addSheetAction:sheetAction2];
    
}

- (void)show {
    [sheetView show];
}


@end
