//
//  YDShareView.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/24.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HiddenHandler)();

@interface YDShareView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSData *videoData;

@property (nonatomic, assign) int from;//

@property (nonatomic, copy) HiddenHandler hiddenHandler;

+ (instancetype)sharedView;
- (void)show;

@end
