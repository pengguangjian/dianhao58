//
//  LaunangeChangeAlterView.h
//  FiveEightAPP
//
//  Created by Mac on 2020/4/1.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectLaunangeHandler)(int sendertag);

@interface LaunangeChangeAlterView : UIView

@property (nonatomic, copy) SelectLaunangeHandler selectLaunangeHandler;

+ (instancetype)sharedView;
- (void)show;


@end

NS_ASSUME_NONNULL_END
