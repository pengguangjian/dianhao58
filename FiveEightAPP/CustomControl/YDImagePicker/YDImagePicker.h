//
//  YDImagePicker.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YDImagePickerFinishAction)(UIImage *image);

@interface YDImagePicker : NSObject

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(YDImagePickerFinishAction)finishAction;


@end
