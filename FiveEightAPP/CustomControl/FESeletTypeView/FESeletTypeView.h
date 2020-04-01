//
//  FESeletTypeView.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/30.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FESeletTypeViewHandler)(id type);

@interface FESeletTypeView : UIView
@property (nonatomic, copy) FESeletTypeViewHandler handler;

+ (instancetype)sharedView:(NSArray*)arr;
- (void)show;

@end

NS_ASSUME_NONNULL_END
