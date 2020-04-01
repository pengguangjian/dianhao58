//
//  FileService.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject

/**
 *  指定路径下单个文件大小
 *
 *  @param path 路径
 *
 *  @return 大小
 */
+ (float)fileSizeAtPath:(NSString *)path;

/**
 *  指定路径下大小（包含SDImageCache）
 *
 *  @param path 路径
 *
 *  @return 大小
 */
+ (float)folderSizeAtPath:(NSString *)path;

/**
 *  清除指定路径缓存
 *
 *  @param path 路径
 */
+ (void)clearCache:(NSString *)path;

@end
