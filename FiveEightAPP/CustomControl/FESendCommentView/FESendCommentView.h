//
//  FESendCommentView.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/23.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FESendCommentViewDelegate <NSObject>

-(void)pinglunSendActionView:(NSString *)value andhuifuid:(NSString *)strhuiid;

@end

@interface FESendCommentView : UIView

@property (nonatomic,retain) NSString *strhuiid;
@property (nonatomic,weak) id<FESendCommentViewDelegate>delegate;

+ (instancetype)sharedView:(NSString*)placeholder;
- (void)show;
@end

NS_ASSUME_NONNULL_END
