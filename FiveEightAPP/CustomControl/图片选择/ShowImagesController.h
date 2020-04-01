//
//  ShowImagesController.h
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImagesController : UIViewController

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *imageNameArray;

@property (nonatomic, assign) BOOL isShowDelBtn;
//@property (nonatomic, strong) NSString *titleValue;

@end
