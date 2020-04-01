//
//  UIView+Masonry_LJC.h
//  MasonryDemo
//
//  Created by caochun on 16/2/17.
//  Copyright © 2016年 caochun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"

@interface UIView (Masonry_LJC)
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
