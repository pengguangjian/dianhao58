//
//  UITableView+Empty.m
//  XiaoShunZiAPP
//
//  Created by Mac on 2018/7/6.
//  Copyright © 2018年 XiaoShunZi. All rights reserved.
//

#import "UITableView+Empty.h"
#import "TPKeyboardAvoidingTableView.h"

@interface UITableView ()

@property (nonatomic,strong) UIView *withoutDataView;

@end

@implementation UITableView (Empty)

+(void)load
{
    //交换reloadData方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadData)), class_getInstanceMethod(self, @selector(lx_reloadData)));
    
    //交换insertSections方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(insertSections:withRowAnimation:)),class_getInstanceMethod(self,@selector(lx_insertSections:withRowAnimation:)));
    
    //交换insertRowsAtIndexPaths方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(insertRowsAtIndexPaths:withRowAnimation:)),  class_getInstanceMethod(self, @selector(lx_insertRowsAtIndexPaths:withRowAnimation:)));
    
    //交换deleteSections方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteSections:withRowAnimation:)),class_getInstanceMethod(self,@selector(lx_deleteSections:withRowAnimation:)));
    
    //交换deleteRowsAtIndexPaths方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteRowsAtIndexPaths:withRowAnimation:)),class_getInstanceMethod(self,@selector(lx_deleteRowsAtIndexPaths:withRowAnimation:)));
}

//reloadData
-(void)lx_reloadData
{
    [self lx_reloadData];
    
    [self reloadPlaceWithoutDataView];
//    NSLog(@"lx_reloadData");
}

//insert
-(void)lx_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self lx_insertSections:sections withRowAnimation:animation];
    [self reloadPlaceWithoutDataView];
}

-(void)lx_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self lx_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reloadPlaceWithoutDataView];
}

//delete
-(void)lx_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self lx_deleteSections:sections withRowAnimation:animation];
    [self reloadPlaceWithoutDataView];
}

-(void)lx_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self lx_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reloadPlaceWithoutDataView];
}

#pragma mark -- 重新设置数据
-(void)reloadPlaceWithoutDataView
{
    [self.withoutDataView removeFromSuperview];
    
    //计算行数
    NSInteger rows = 0;
    for (int i = 0; i < self.numberOfSections; i++) {
        rows += [self numberOfRowsInSection:i];
    }
    
    //如果存在数据
    if (rows > 0 ) {
        return;
    }
    
    if (![self isKindOfClass:[TPKeyboardAvoidingTableView class]]) {
        return;
    } else {
        TPKeyboardAvoidingTableView *tb = (TPKeyboardAvoidingTableView *)self;
        if (!tb.isShowWithoutDataView) {
            return;
        }
    }
    
//    //是否有偏移
//    CGFloat height = self.contentInset.top;
//
//    //判断是否有头
//    if (self.tableHeaderView) {
//        height += self.tableHeaderView.height;
//    }
//
//    if (height < self.height/2.0-100) {
//        height = self.height/2.0-100;
//    }else {
//        height += 30;
//    }
    
    
    __block BOOL isHaveNetwork;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
//                NSLog(@"未知网络");
                break;
            case 0:
//                NSLog(@"网络不可达");
                break;
            case 1:
//                NSLog(@"GPRS网络");
                break;
            case 2:
//                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            NSLog(@"有网");
            isHaveNetwork = YES;
            [self initWithoutDataView:@"img_blank" withTitle:NSLocalizedString(@"zhelikongkongruye", nil)];
        }else{
//            NSLog(@"没网");
            isHaveNetwork = NO;
            [self initWithoutDataView:@"img_nonetwork" withTitle:NSLocalizedString(@"wangluozoudiule", nil)];
        }
    }];
    
    
    
}

- (void)initWithoutDataView:(NSString*)imageName withTitle:(NSString*)title {
    
    if (self.withoutDataView) {
        [self.withoutDataView removeFromSuperview];
    }
    
    self.withoutDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, self.frame.size.height)];
    self.withoutDataView.backgroundColor = RGB(248, 248, 248);
    self.withoutDataView.tag = WITHOUTDATAVIEWTAG;
    [self addSubview:self.withoutDataView];
    
    
    UIImageView *coverImage = [[UIImageView alloc]init];
    coverImage.image = [UIImage imageNamed:imageName];
    [self.withoutDataView addSubview:coverImage];
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.withoutDataView);
        make.top.mas_equalTo((self.withoutDataView.frame.size.height-150-20-16)/2.0-70);
        make.size.mas_equalTo(CGSizeMake(125, 125));
    }];
    
    
    UILabel *cartLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 14)];
    cartLabel.font = [UIFont systemFontOfSize:14];
    cartLabel.text = title;
    cartLabel.textColor = RGB(200, 200, 200);
    cartLabel.textAlignment = NSTextAlignmentCenter;
    [self.withoutDataView addSubview:cartLabel];
    
    [cartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.withoutDataView);
        make.top.equalTo(coverImage.mas_bottom).with.offset(20);
    }];
    
//    TPKeyboardAvoidingTableView *tb = (TPKeyboardAvoidingTableView *)self;
//    if (tb.isClickWithoutDataView) {
//        cartLabel.text = @"找服务";
//        
//        cartLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//        [cartLabel addGestureRecognizer:tapGesture];
//    }
    
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [tabBar setSelectedIndex:0];
    [[Util topViewController].navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark -- getter & setter

-(UIView *)withoutDataView
{
    return objc_getAssociatedObject(self, @selector(withoutDataView));
}

-(void)setWithoutDataView:(UIView *)withoutDataView
{
    objc_setAssociatedObject(self, @selector(withoutDataView), withoutDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
