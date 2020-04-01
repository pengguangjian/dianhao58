//
//  MSSheetAction.h
//  MeiShi
//
//  Created by caochun on 16/4/19.
//  Copyright © 2016年 More. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSheetAction : UIView

@property (strong, nonatomic) UIImage *lImage;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) UIImage *rImage;

@property (nonatomic, copy) void (^btnClickBlock)();

//+ (instancetype)sharedView;

- (void)initLeftImage:(UIImage*)lImage andContent:(NSString*)content andRightImage:(UIImage*)rImage;

@end
