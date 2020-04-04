//
//  AppDelegate.m
//  FiveEight
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "FindVC.h"
#import "PublishVC.h"
#import "MessageVC.h"
#import "MeVC.h"
#import <ZaloSDK/ZaloSDK.h>
#import "AppDelegate+ThirdPartyRegister.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NetWorkManager instance] startListen]; //程序启动要开启网络状态监听-
    
    //        // 启动图片延时: 1秒
    //        [NSThread sleepForTimeInterval:1];

    //获取存储在本地的GHUser对象并更新
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User*)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    [User updateUser:user];
    
    [[ZaloSDK sharedInstance] initializeWithAppId:@"4417178685282046391"];
    
    //注册ShareSDK+
    [self registerShareSDK];
    //注册高德地图
//    [self registerAMap];
    //初始化MTA统计
//    [self registerMTASDK];
    //注册Bugly
//    [self registerBuglySDK];
    
    //初始化JPush APNs代码
//    [self initJPush_APNs];
    //初始化JPush
//    [self initJPush:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createRootVC];
    [self.window makeKeyAndVisible];
    
    [self removeAppleLoginState];
    
    if (@available(iOS 13.0, *)) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    
    return YES;
}
///解除苹果登录状态
-(void)removeAppleLoginState
{
    if([User isNeedLogin]==NO)
    if (@available(iOS 13.0, *)) {
        
       NSString *appleUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appleUserID"];
       if ([NSString nullToString:appleUserID].length<1) {//为空
           return;
       }

       ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
       [appleIDProvider getCredentialStateForUserID:appleUserID completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
           switch (credentialState) {
               case ASAuthorizationAppleIDProviderCredentialAuthorized:
                   // Apple ID credential is valid
                   NSLog(@"Apple登录_Apple ID credential is valid");
                   break;
                   
               case ASAuthorizationAppleIDProviderCredentialRevoked:
                   // Apple ID Credential revoked, handle unlink
                   NSLog(@"Apple登录_Apple ID Credential revoked, handle unlink");
//                   [self unbindApple];  //跟自己服务器解绑
//                   [User clearUser];
                   break;
                   
               case ASAuthorizationAppleIDProviderCredentialNotFound:
                   // Apple ID Credential not found, show login UI
                   NSLog(@"Apple登录_Apple ID Credential not found, show login UI");
//                   [User clearUser];
                   
                   break;
                   
               case ASAuthorizationAppleIDProviderCredentialTransferred:
                   NSLog(@"Apple登录_Apple ID Credential transferred");
                   break;
           }
       }];
    }
}

- (void)createRootVC {
    
    HomeVC *homeVC = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:Nil];
    homeVC.tabBarItem = [self createTabBarItem:NSLocalizedString(@"Home", nil) imageNamed:@"ic_home_n" selectedImageNamed:@"ic_home_s"];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    FindVC *findVC = [[FindVC alloc]initWithNibName:@"FindVC" bundle:Nil];
    findVC.tabBarItem = [self createTabBarItem:NSLocalizedString(@"Find", nil) imageNamed:@"ic_order_n" selectedImageNamed:@"ic_order_s"];
    UINavigationController *findNC = [[UINavigationController alloc] initWithRootViewController:findVC];
    
    PublishVC *publishVC = [[PublishVC alloc]initWithNibName:@"PublishVC" bundle:Nil];
    publishVC.tabBarItem = [self createTabBarItem:NSLocalizedString(@"Publish", nil) imageNamed:@"ic_publish" selectedImageNamed:@"ic_publish"];
    UINavigationController *publishNC = [[UINavigationController alloc] initWithRootViewController:publishVC];
    
    MessageVC *messageVC = [[MessageVC alloc]initWithNibName:@"MessageVC" bundle:Nil];
    messageVC.tabBarItem = [self createTabBarItem:NSLocalizedString(@"Message", nil) imageNamed:@"ic_message_n" selectedImageNamed:@"ic_message_s"];
    UINavigationController *messageNC = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    MeVC *meVC = [[MeVC alloc]initWithNibName:@"MeVC" bundle:Nil];
    meVC.tabBarItem = [self createTabBarItem:NSLocalizedString(@"Me", nil) imageNamed:@"ic_my_n" selectedImageNamed:@"ic_my_s"];
    UINavigationController *meNC = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    //tabBar设置
    _tabBarCtrl = [[FETabBarController alloc]init];
    
    //选中时的颜色
    self.tabBarCtrl.feTabbar.tintColor = [UIColor colorWithRed:234/255.0 green:58/255.0 blue:60/255.0 alpha:1];
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.tabBarCtrl.feTabbar.translucent = NO;
    
    self.tabBarCtrl.feTabbar.position = FETabBarCenterButtonPositionBulge;
    self.tabBarCtrl.feTabbar.centerImage = [UIImage imageNamed:@"tabbar_add_yellow"];
    
    _tabBarCtrl.feDelegate = self;
    _tabBarCtrl.viewControllers = @[homeNC, findNC, publishNC, messageNC, meNC];
    
    //Tabbar 未选中颜色
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        [UITabBar appearance].tintColor = TABBARUNSELECTEDTINTCOLOR;
    } else {
        [UITabBar appearance].unselectedItemTintColor = TABBARUNSELECTEDTINTCOLOR;
    }
    [UITabBar appearance].selectedImageTintColor = RGB(234, 58, 60);
    
    //TabBar的分割线
    //    [[UITabBar appearance] setShadowImage:[UIImage new]];
    //    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    CGRect rect = CGRectMake(0, 0, DEVICE_Width, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, SEPARATORCOLOR.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UITabBar appearance] setShadowImage:img];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    //TabBar的背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    self.window.rootViewController = _tabBarCtrl;
}

- (UITabBarItem *)createTabBarItem:(NSString *)title imageNamed:(NSString *)imageNamed selectedImageNamed:selectedImageNamed {
    
    UIImage *image = [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:image
                                                     selectedImage:selectedImage];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    
    return tabBarItem;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    UIApplication *app = [UIApplication sharedApplication];
    __block  UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication*)application shouldAllowExtensionPointIdentifier:(NSString*)extensionPointIdentifier
{
    return NO;
}

#pragma mark -- UITabBarControllerDelegate
// 使用feTabBarController 自定义的 选中代理
- (void)feTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if (tabBarController.selectedIndex == 2){
        if ([User isNeedLogin]) {
            [Util LoginVC:YES];
            [tabBarController setSelectedIndex:0];
            return;
        }
        [self rotationAnimation];
    }else {
        if (tabBarController.selectedIndex == 3)
        {
            if ([User isNeedLogin]) {
                [Util LoginVC:YES];[tabBarController setSelectedIndex:0];
                return;
            }
        }
        
        [self.tabBarCtrl.feTabbar.centerBtn.layer removeAllAnimations];
    }
    
}



//旋转动画
- (void)rotationAnimation{
    if ([@"key" isEqualToString:[self.tabBarCtrl.feTabbar.centerBtn.layer animationKeys].firstObject]){
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI_4*3];
    rotationAnimation.duration = 0.5;
    rotationAnimation.repeatCount = 1;//HUGE;
//    rotationAnimation.removedOnCompletion = NO;
//    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.tabBarCtrl.feTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *) options {
    return [[ZDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
}


@end
