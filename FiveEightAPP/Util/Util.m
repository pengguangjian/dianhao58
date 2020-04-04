//
//  Util.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "LoginVC.h"

#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>

#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation Util

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [Util getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";

}



+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

+ (NSString*)getSmallImageUrlStr:(NSString*)originalUrl withWidth:(int)w withHeight:(int)h {
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%zi/h/%zi", originalUrl, w*3, h*3];
    return newUrlStr;
}

+ (NSString*)getUDID {
    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (void)LoginVC:(BOOL)animated {
    
    UIViewController *vc = [Util topViewController];
    
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    loginVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginNC.modalPresentationStyle  = UIModalPresentationFullScreen;
    [vc presentViewController:loginNC animated:animated completion:^{

    }];
}

+ (void)changeRootVC {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[Util topViewController] dismissViewControllerAnimated:YES completion:^{
        }];
        
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        UINavigationController *nc = app.window.rootViewController;
//        NSArray *viewControllers = nc.viewControllers;
//        UIViewController *firstVC = [viewControllers firstObject];
//        if ([firstVC isKindOfClass:[LoginVC class]]) {
//            [app createRootVC];
//        } else {
//
//            UIViewController *vc = [Util topViewController];
//            if ([[Util topViewController] isKindOfClass:[LoginVC class]]||
//                [[Util topViewController] isKindOfClass:[SettingPwdVC class]]) {
//                [[Util topViewController] dismissViewControllerAnimated:YES completion:^{
//                }];
//                return;
//            }
//
//            if ([[Util topViewController] isKindOfClass:[BindPhoneVC class]]) {
//                [[Util topViewController].navigationController popViewControllerAnimated:NO];
//                [[Util topViewController] dismissViewControllerAnimated:YES completion:^{
//                }];
//                return;
//            }
//
//            if ([[Util topViewController] isKindOfClass:[SettingVC class]]) {
//                //返回首
//                [[Util topViewController].navigationController popToRootViewControllerAnimated:NO];
//                UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
//                [tabBar setSelectedIndex:0];
//                return;
//            }
//        }
    });
}

+ (NSString *)filePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"shoppingcartData.plist"];
}

+ (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

//+ (NSMutableArray *)getShoppingCartDataArr
//{
//    NSString *path = [Util filePath];
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//}
//
//+ (void)saveShoppingCartDataArr:(NSMutableArray *)arr
//{
//    NSString *path = [Util filePath];
//    [NSKeyedArchiver archiveRootObject:arr toFile:path];
//}


/**
 *  MD5加密
 *
 *  @param input NSString
 *
 *  @return NSString
 */
+ (NSString *)MD5Digest:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

+ (NSString *)time_timestampToString:(double)timestamp {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr = [dateFormat stringFromDate:confromTimesp];
    
    return dateStr;
    
}

+ (NSString *)time_timestampToStr:(double)timestamp {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [dateFormat stringFromDate:confromTimesp];
    
    return dateStr;
    
}

+ (NSString *)dateTimeToString:(double)timestamp {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:@"MM-dd HH:mm"];
    
    NSString *dateStr = [dateFormat stringFromDate:confromTimesp];
    
    return dateStr;
    
}

+ (NSString *)time_DatestampToString:(double)timestamp {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [dateFormat stringFromDate:confromTimesp];
    
    return dateStr;
    
}



+ (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)setNavigationBar:(UINavigationBar*)nav andBackgroundColor:(UIColor*)color andIsShowSplitLine:(BOOL)isHidden
{
//    if ([nav isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
//    {
//        //隐藏分割线
//        for (UIView *view in nav.subviews)
//        {
//            if ([view isKindOfClass:[UIImageView class]])
//            {
//                view.hidden = isShow;
//            }
//        }
//        
//        //修改背景色为透明
//        nav.backgroundColor = color;
//    }
//    else if ([nav isKindOfClass:NSClassFromString(@"_UIBackdropView")])
//    {
//        
//        //_UIBackdropEffectView是_UIBackdropView的子视图，这是只需隐藏父视图即可
//        
//        nav.hidden = isShow;
//        
//        
//    }
//    
//    for (UIView *view in nav.subviews)
//    {
//        [self setNavigationBar:view andBackgroundColor:color andIsShowSplitLine:isShow];
//    }
    
    //去掉导航栏下面黑线
    if ([nav respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        NSArray *list = nav.subviews;
        
        for (id obj in list)
        {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
            {//10.0的系统不一样
                UIView *view = (UIView*)obj;
                
                if (view.tag == 100) {//设置自定义分割线是否显示
                    view.hidden = isHidden;
                    [nav bringSubviewToFront:view];
                    continue;
                }
                
                for (id obj2 in view.subviews) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *image = (UIImageView*)obj2;
                        if (image.frame.size.height <= 0.5) {//隐藏系统分割线
                            image.hidden = YES;
                        }
                        
                    }
                }
            } else {
                
                if ([obj isKindOfClass:[UIImageView class]])
                {
                    
                    UIImageView *imageView = (UIImageView *)obj;
                    NSArray *list2 = imageView.subviews;
                    for (id obj2 in list2)
                    {
                        if ([obj2 isKindOfClass:[UIImageView class]])
                        {
                            
                            UIImageView *imageView2 = (UIImageView *)obj2;
                            if (imageView2.frame.size.height <= 0.5) {//隐藏系统分割线
                                imageView2.hidden = YES;
                            }
                        }
                    }
                }
                
                if ([obj isKindOfClass:[UIView class]]) {//设置自定义分割线是否显示
                    UIView *view = (UIView*)obj;
                    
                    if (view.tag == 100) {
                        view.hidden = isHidden;
                        
                        [nav bringSubviewToFront:view];
                        continue;
                    }
                }
                
                
                
            }
        }
    }
    
    BOOL isWhiteColor = CGColorEqualToColor(color.CGColor, [UIColor whiteColor].CGColor);
    BOOL isClearColor = CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor);
    
    nav.translucent = YES;
    CGRect rect = CGRectMake(0.0, 0.0, DEVICE_Width, SafeAreaTopHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = nil;
    
    if (isWhiteColor || isClearColor) {
        image = UIGraphicsGetImageFromCurrentImageContext();
    } else {
        image = [UIImage imageNamed:@"nav_bg"];
    }
    UIGraphicsEndImageContext();
//    [nav setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [nav setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
//    nav.clipsToBounds = YES;
    
//     CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//     UIColor *color1= DEFAULTCOLOR1;
//     UIColor *color2 = DEFAULTCOLOR2;
//     gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
//     gradientLayer.locations = @[@0.0, @1.0];
//     gradientLayer.startPoint = CGPointMake(0, 0);
//     gradientLayer.endPoint = CGPointMake(1.0, 0);
//     gradientLayer.frame = CGRectMake(0, -20, DEVICE_Width, 64);;
//     [nav.layer addSublayer:gradientLayer];
    
    
}

+ (BOOL)validateVCode:(NSString*)vCode {
    
    NSString *VCODE = @"^\\d{6}$";
    
    NSPredicate *regextestv = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VCODE];
    
    if ([regextestv evaluateWithObject:vCode] == YES) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码170
     * 移动：134[0-8],135,136,137,138,139,145,146,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,155,156,176,185,186
     * 电信：133,1349,153,177,180,181,189,199
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9]|98)\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,178,182,183,184,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|7[0]|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,155,156,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[0-9]|5[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,181,189
     22         */
    NSString * CT = @"^1((3[0-9]|5[0-9]|7[0-9]|8[0-9]|9[0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 隐藏手机号中间4位
+ (NSString *)getConcealPhoneNumber:(NSString *)phoneNum{
    if(phoneNum.length<7)return phoneNum;
    NSString *numberStr = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberStr;
}

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard
{
    //    BOOL flag;
    //    if (identityCard.length <= 0) {
    //        flag = NO;
    //        return flag;
    //    }
    //    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    //    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //    return [identityCardPredicate evaluateWithObject:identityCard];
    BOOL isFlag = NO;
    
    NSString *regIDCard = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regIDCard];
    if ([identityCardPredicate evaluateWithObject:identityCard]) {
        
        if (identityCard.length == 18) {
            NSArray *idCardWi = [[NSArray alloc] initWithObjects: @"7", @"9",
                                 @"10", @"5", @"8", @"4", @"2", @"1", @"6",
                                 @"3", @"7", @"9", @"10", @"5", @"8", @"4",
                                 @"2", nil];//将前17位加权因子保存在数组里
            NSArray *idCardY = [[NSArray alloc] initWithObjects:@"1", @"0",
                                @"10", @"9", @"8", @"7", @"6", @"5", @"4",
                                @"3", @"2", nil]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            
            int idCardWiSum = 0;
            
            for (int i = 0; i<17; i++) {
                idCardWiSum += [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue] * [idCardWi[i] integerValue];
            }
            
            int idCardMod = idCardWiSum %11;//计算出校验码所在数组的位置
            NSString *idCardLast = [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            if (idCardMod == 2) {
                if ([idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"]) {
                    isFlag = YES;
                }else{
                    isFlag = NO;
                }
            }else{
                if ([idCardLast integerValue] == [idCardY[idCardMod] integerValue]) {
                    isFlag = YES;
                } else {
                    isFlag = NO;
                }
            }
            
        }else if(identityCard.length == 15){//15位默认为正确
            isFlag = YES;
        }
        
    }else{
        isFlag = NO;
    }
    
    return isFlag;
}

// 获得应用版本号
+ (NSString *)getApplicationVersion {
    
    //application version (use short version preferentially)
    NSString *applicationVersion=nil;
    applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([applicationVersion length] == 0)
    {
        applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    }
    return applicationVersion;
}


+ (NSInteger)getIntervalDay:(NSDate*)sDate withEndDate:(NSDate*)eDate {
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //世纪
    NSInteger era  = kCFCalendarUnitEra;
    
    //年
    NSInteger year = kCFCalendarUnitYear;
    
    //月
    NSInteger month = kCFCalendarUnitMonth;
    
    NSInteger day = kCFCalendarUnitDay;
    
    //小时
    NSInteger hour = kCFCalendarUnitHour;
    
    //分钟
    NSInteger minute = kCFCalendarUnitMinute;
    
    //秒
    NSInteger second = kCFCalendarUnitSecond;
    
    NSDateComponents *compsEra = [calender components:era fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsYear = [calender components:year fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsMonth = [calender components:month fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsDay = [calender components:day fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsHour = [calender components:hour fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsMinute = [calender components:minute fromDate:sDate toDate:eDate options:0];
    NSDateComponents *compsSecond = [calender components:second fromDate:sDate toDate:eDate options:0];
    
//    NSLog(@"相差世纪个数 = %ld",[compsEra era]);
//    NSLog(@"相差年个数 = %ld",[compsYear year]);
//    NSLog(@"相差月个数 = %ld",[compsMonth month]);
//    NSLog(@"相差天个数 = %ld",[compsDay day]);
//    NSLog(@"相差小时个数 = %ld",[compsHour hour]);
//    NSLog(@"相差分钟个数 = %ld",[compsMinute minute]);
//    NSLog(@"相差秒个数 = %ld",[compsSecond second]);
    
    // 3、获取时间戳（相对于1970年）
    CGFloat timestamp = eDate.timeIntervalSince1970;
//    NSLog(@"距离1970年有多少秒 = %f",timestamp);
    
    // 4、计算距离现在有多少秒
    CGFloat sinceNow = sDate.timeIntervalSinceNow;
//    NSLog(@"距离现在有多少秒 = %f",fabs(sinceNow));
    
    return [compsDay day];
    
}

// 根据颜色生成UIImage
+ (UIImage*)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}
///判断输入的是否是中文
+ (BOOL)isChinese:(NSString *)string {
    NSString *regex = @"^[\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [Util getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}


+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}


//利用CCRandomGenerateBytes实现随机字符串的生成
+ (NSString *)randomString:(NSInteger)length {
    length = length/2;
    unsigned char digest[length];
    CCRNGStatus status = CCRandomGenerateBytes(digest, length);
    NSString *s = nil;
    if (status == kCCSuccess) {
        s = [Util stringFrom:digest length:length];
    }
    
    return s;
}
//将bytes转为字符串
+ (NSString *)stringFrom:(unsigned char *)digest length:(NSInteger)leng {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < leng; i++) {
        [string appendFormat:@"%02x",digest[i]];
    }

    return string;
}

//当前时间戳
+ (NSString *)currentDateInterval {
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    return timeSp;
}



+ (NSString *)dicToMD5Str:(NSDictionary*)dic {
    
    NSArray *keyArray = [dic allKeys];
    
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    sign = [sign stringByReplacingOccurrencesOfString:@":" withString:@"="];
    return sign;
    
}

//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str
{
    CGSize detailsLabSize = size;
    NSDictionary *detailsLabAttribute = @{NSFontAttributeName: font};
    //ios7方法，获取文本需要的size
    CGSize  msize =[str boundingRectWithSize:detailsLabSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:detailsLabAttribute context:nil].size;
    return msize;
}

@end
