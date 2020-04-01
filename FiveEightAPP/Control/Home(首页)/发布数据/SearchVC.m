//
//  SearchVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/26.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "SearchVC.h"
#import "SearchResultObj.h"

@interface SearchVC ()
{
    NSMutableArray *_dataArray;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)searchKeywords:(NSString*)keywords {
    
    [self loadFirstData];
    
}

- (void)loadFirstData {
    
    self.page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self loadMoreData];
}

- (void)loadMoreData {
    
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] ) {
                
                NSArray *dic = [rd.data valueForKey:@"list"];
                NSArray *tempArr  = [SearchResultObj mj_objectArrayWithKeyValuesArray:dic];
                
                NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:_dataArray];
                [mutableArray addObjectsFromArray:tempArr];
                _dataArray = [mutableArray mutableCopy];
                
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
                
                [self endHeaderRefreshing];
                [self endFooterRefreshing];
                
                if (tempArr.count < ONE_PAGE) {
                    // 变为没有更多数据的状态
                    [self endFooterRefreshingWithNoMoreData];
                }
                self.page++;
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.msg];
            }
        });
        
    };
    
    NSMutableDictionary *dataDic = @{@"lang":@"zh-cn",
                                     @"cityid":@"1",
                                     @"page":[NSNumber numberWithInt:self.page],
                                     @"row":[NSNumber numberWithInt:ONE_PAGE],
                                     @"keywords": @"",
                                     };
    
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"frontend.common/search"];
    
}

@end
