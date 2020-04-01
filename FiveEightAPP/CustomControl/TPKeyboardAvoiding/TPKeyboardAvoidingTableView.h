//
//  TPKeyboardAvoidingTableView.h
//  TPKeyboardAvoiding
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@interface TPKeyboardAvoidingTableView : UITableView <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, assign) BOOL isShowWithoutDataView;
@property(nonatomic, assign) BOOL isClickWithoutDataView;

- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
