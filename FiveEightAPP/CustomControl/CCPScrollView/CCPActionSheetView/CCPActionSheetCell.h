//
//  CCPActionSheetCell.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPActionSheetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopCconstraint;

@end
