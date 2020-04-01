//
//  CityAreaGroup.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityAreaGroup : NSObject

/**
 *  groupTitle
 */
@property (nonatomic,copy) NSString *groupTitle;
/**
 *  关注的模型类型
 */
@property (nonatomic,strong)NSMutableArray *cityAreaArr;
/**
 *   根据首字母将相同首字母的字符串生成对应的群组 和一个个成员模型
 *
 *   @param dataArray 原始数组
 *   @param title     标题
 *
 *   @return 返回一个组模型
 */
+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
