//
//  YDSelectSexView.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/30.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectSexHandler)(int sex);

@interface YDSelectSexView : UIView

@property (nonatomic, copy) SelectSexHandler selectSexHandler;

+ (instancetype)sharedView;
- (void)show;

@end
