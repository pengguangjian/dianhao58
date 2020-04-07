//
//  XieYiAlterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/12/9.
//  Copyright © 2019 penggj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XieYiAlterView : UIView

@property (nonatomic , retain) UINavigationController *nav;

-(id)initWithFrame:(CGRect)frame andtitle:(NSString *)strtitle andcontent:(NSString *)strcontent;

@end

NS_ASSUME_NONNULL_END
