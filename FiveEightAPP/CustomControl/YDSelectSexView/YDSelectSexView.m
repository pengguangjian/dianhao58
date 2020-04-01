//
//  YDSelectSexView.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/30.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "YDSelectSexView.h"

#import "MSSheetView.h"

@interface YDSelectSexView ()
{
    
    MSSheetView *sheetView;
}
@end

@implementation YDSelectSexView

+ (instancetype)sharedView {
    
    static dispatch_once_t once;
    static YDSelectSexView *selectSexView;
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
    [sheetAction initLeftImage:nil andContent:NSLocalizedString(@"nan", nil) andRightImage:nil];
    [sheetAction setBtnClickBlock:^(){
        
        if (self.selectSexHandler) {
            
            self.selectSexHandler(1);
            
        }
        
    }];
    
    
    MSSheetAction *sheetAction1 = [[MSSheetAction alloc] init];
    [sheetAction1 initLeftImage:nil andContent:NSLocalizedString(@"nv", nil) andRightImage:nil];
    [sheetAction1 setBtnClickBlock:^(){
        
        if (self.selectSexHandler) {
            
            self.selectSexHandler(2);
            
        }
        
    }];
    
    MSSheetAction *sheetAction2 = [[MSSheetAction alloc] init];
    [sheetAction2 initLeftImage:nil andContent:NSLocalizedString(@"baomi", nil) andRightImage:nil];
    [sheetAction2 setBtnClickBlock:^(){
        
        if (self.selectSexHandler) {
            
            self.selectSexHandler(3);
            
        }
        
    }];
    
    
    sheetView = [MSSheetView sharedView];
    sheetView.title = NSLocalizedString(@"xuanzhexingbie", nil);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:sheetView];
    
    [sheetView addSheetAction:sheetAction];
    [sheetView addSheetAction:sheetAction1];
    [sheetView addSheetAction:sheetAction2];
    
    
}

- (void)show {
    [sheetView show];
}



@end
