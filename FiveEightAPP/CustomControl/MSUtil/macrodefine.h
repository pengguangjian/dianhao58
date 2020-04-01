//
//  macrodefine.h
//  MeishiMainDemo
//
//  Created by caochun on 16/2/16.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MSHead.h"

#ifndef macrodefine_h
#define macrodefine_h

//keyWindow,屏幕宽 屏幕高
#define KEY_WINDOW                [[UIApplication sharedApplication] keyWindow]
#define screenWidth               [[UIScreen mainScreen] bounds].size.width
#define screenHeight              [[UIScreen mainScreen] bounds].size.height

///RGB
#define MSRGBA(r, g, b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define MSRGB(r, g, b) MSRGBA(r,g,b,1)

///请使用 MSLog代替NSLog MSLog在发布的产品不会打印日志
#ifdef DEBUG
#define MSLog(fmt,...);
#else
#define MSLog(fmt,...);
#endif


#define IOS_VERSION            [[[UIDevice currentDevice] systemVersion] floatValue]


#define IS_IPAD                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define APPVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]



#define customErrorDoMain @"imqiuhang_customErrorDoMain"

#define tabBarHeight 49.f

//>>>>>>>>>>>>>>>>>>>>>颜色,字体等公共属性

/*颜色*/

#define YMSViewBackgroundColor         [MSUtil colorWithHexString:@"f5f5f5"]

//app的文本标题颜色
#define YMSTitleColor                  [MSUtil colorWithHexString:@"333333"]

//通用的副标题颜色
#define YMSSubTitleLableColor          [MSUtil colorWithHexString:@"aaaaaa"]

//展位图统一的背景颜色
#define YMSPlaceHolderBgColor           [MSUtil colorWithHexString:@"#F5F5F5"]

//统一的列表线条颜色
#define YMSLineViewColor                [MSUtil colorWithHexString:@"#E8E8E8"]


//品牌色
#define YMSBrandColor                  [MSUtil colorWithHexString:@"ff807a"]

//导航栏的背景颜色
#define YMSNavBarTinkColor              [MSUtil  whiteColor]

//导航栏的标题颜色
#define YMSNavTitleColor                [MSUtil colorWithHexString:@"333333"]
//状态栏
#define YMSStatusBarStyle              UIStatusBarStyleDefault

#define YMSTabBarBarTintColor          [UIColor  whiteColor]


/*字体*/

//#define defaultFont(s) [UIFont fontWithName:@"HYQiHei-DZS" size:s]

#define defaultFont(s) [UIFont systemFontOfSize:s]
#define systemFont(s)  [UIFont systemFontOfSize:s]

#endif /* macrodefine_h */
