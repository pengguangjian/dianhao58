//
//  AlertViewWithBlockOrSEL.h
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewWithBlockOrSEL : UIAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
- (void)setCancelButtonWithTitle:(NSString *)title;
- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object;
- (void)setCancelButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock;
- (void)addOtherButtonWithTitle:(NSString *)title;
- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object;
- (void)addOtherButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock;

@end
