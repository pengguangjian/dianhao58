//
//  PublishVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/11.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import "PublishVC.h"
#import "PublishTypeVC.h"

@interface PublishVC ()

@end

@implementation PublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [Util setNavigationBar:self.navigationController.navigationBar andBackgroundColor:[UIColor clearColor] andIsShowSplitLine:YES];
    
    
    PublishTypeVC *vc = [[PublishTypeVC alloc] initWithNibName:@"PublishTypeVC" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

@end
