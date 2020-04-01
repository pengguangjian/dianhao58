//
//  ContentDetailVC.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/19.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentDetailVC : BaseVC

@property (strong, nonatomic) NSNumber *contentId;

@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *contactBtn;
@property (strong, nonatomic) IBOutlet UIButton *focusPNBtn;
- (IBAction)commentBtnOnTouch:(id)sender;
- (IBAction)contactBtnOnTouch:(UIButton*)btn;
- (IBAction)focusPNBtnOnTouch:(id)sender;

@end

NS_ASSUME_NONNULL_END
