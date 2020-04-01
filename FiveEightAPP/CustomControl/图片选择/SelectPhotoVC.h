//
//  SelectPhotoVC.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "BaseVC.h"

@interface SelectPhotoVC : BaseVC
@property (nonatomic, strong) NSMutableArray    *photoArray;  // 图片数组
@property (nonatomic, strong) NSMutableArray    *editArray;   // 删除后的图片数组

@property (nonatomic, strong) UICollectionView    *photoView;
@property (nonatomic, strong) NSMutableArray    *imageNameArray;   // 上传的图片名

@property (nonatomic, strong) UIImage   *videoImage;  //视频的截图
@property (nonatomic, strong) NSData    *videoData;   //视频文件
@property (nonatomic, copy) NSString    *videoName;   //视频的名字
@property (nonatomic, assign) double    videoLength;  //视频的大小 (byte)
@property (nonatomic, assign) BOOL   isCamrea;   //是否是拍的照片

- (IBAction)selectPhotoBtnOnTouch:(id)sender;
- (IBAction)cameraBtnOnTouch:(id)sender;
- (IBAction)audioBtnOnTouch:(id)sender;



@end
