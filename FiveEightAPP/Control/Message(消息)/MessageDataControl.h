//
//  MessageDataControl.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageDataControl : NSObject
@property (nonatomic , retain) NSArray *arrList;

-(void)messageListData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back;


@end

NS_ASSUME_NONNULL_END
