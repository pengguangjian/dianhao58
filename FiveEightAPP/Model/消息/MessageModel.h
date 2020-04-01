//
//  MessageModel.h
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property (nonatomic , retain) NSString *time;
@property (nonatomic , retain) NSString *content;
@property (nonatomic , retain) NSString *article_id;
@property (nonatomic , retain) NSString *msg_type;
@property (nonatomic , retain) NSString *url;
@property (nonatomic , assign) float fcellheight;

+(MessageModel *)dicModelValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
