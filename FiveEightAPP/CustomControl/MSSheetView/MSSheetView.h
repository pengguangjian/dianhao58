//
//  MSSheetView.h
//  MeiShi
//
//  Created by caochun on 16/4/19.
//  Copyright © 2016年 More. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSheetAction.h"

@interface MSSheetView : UIView

@property (strong, nonatomic) NSString *title;

+ (instancetype)sharedView;

- (void)addSheetAction:(MSSheetAction*)sheetAction;

- (void)setEnsureBtnTitle:(NSString*)title;

- (void)show;

@end
