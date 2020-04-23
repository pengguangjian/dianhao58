//
//  SelectCityAreaVC.m
//  FiveEightAPP
//
//  Created by caochun on 2019/9/27.
//  Copyright © 2019 DianHao. All rights reserved.
//

#import "SelectCityAreaVC.h"

#import "PinYin4Objc.h"
#import "NSMutableArray+FilterElement.h"
#import "CityAreaGroup.h"
#import "CityArea.h"

@interface SelectCityAreaVC ()
{
    NSMutableArray *searchResultArr; // 搜索结果的数组
    NSMutableArray *array; // 数据源数组 分组和每个区的模型
    NSMutableArray *sectionIndexs; // 放字母索引的数组
    
    NSMutableArray *dataArr;
}
@end

@implementation SelectCityAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"xuanzhediqu", nil) leftImage:[UIImage imageNamed:@"ic_stat_back_n"] andRightImage:nil];
    
    [self initWithRefreshTableView:CGRectMake(0, SafeAreaTopHeight, DEVICE_Width, DEVICE_Height-SafeAreaTopHeight)];
    
    self.tableView.mj_header = nil;
    //    self.tableView.mj_footer = nil;
    //    self.tableView.isShowWithoutDataView = YES;
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.0001f)];
    
    self.tableView.separatorColor = SEPARATORCOLOR;
    
    [self getOpenedCity];
    
}

- (void)leftBtnOnTouch:(id)sender
{
    if (_isFormPublish) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getOpenedCity {
    
    HttpManager *hm = [HttpManager createHttpManager];
    hm.responseHandler = ^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
            
            if ([rd.code isEqualToString:SUCCESS] ) {
                
                NSArray *dic = [rd.data valueForKey:@"list"];
                dataArr = [CityArea mj_objectArrayWithKeyValuesArray:dic];
                
                [SVProgressHUD dismiss];
                //                [self.tableView reloadData];
                
                [self dealData];
                
                [self endHeaderRefreshing];
                [self endFooterRefreshing];
                
                // 变为没有更多数据的状态
                [self endFooterRefreshingWithNoMoreData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:rd.msg];
            }
        });
        
    };
    
    NSString *userSettingLanguage = [NSBundle currentLanguage];
    
    if (!([userSettingLanguage isEqualToString:@"zh-Hans"]||
        [userSettingLanguage isEqualToString:@"vi"])) {
        userSettingLanguage = @"vi";
    }
    
    if([userSettingLanguage isEqualToString:@"vi"])
    {
        userSettingLanguage = @"vn";
        
    }
    else
    {
        userSettingLanguage = @"zh-cn";
    }
    
    
    NSDictionary *dataDic = @{@"lang":userSettingLanguage,@"cityid":_oc.id};
    
    [hm getRequetInterfaceData:dataDic withInterfaceName:@"frontend.city/area"];
    
}

- (void)dealData {
    
    sectionIndexs = [NSMutableArray array];
    for (CityArea *ca in dataArr) {
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:ca.name];
        [sectionIndexs addObject:header];
    }
    // 去除数组中相同的元素
    sectionIndexs = [sectionIndexs filterTheSameElement];
    // 数组排序
    [sectionIndexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        return [str1 compare:str2];
    }];
    
    // 将排序号的首字母数组取出 分成一个个组模型 和组模型下边的一个个 item
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *sectionTitle in sectionIndexs) {
        CityAreaGroup *group = [CityAreaGroup getGroupsWithArray:dataArr groupTitle:sectionTitle];
        if ([group.groupTitle isEqualToString:@"#"]) {
            // 默认 #开头的放在数组的最前边 后边才是 A-Z
            [tempArray insertObject:group atIndex:0];
        }else{
            [tempArray addObject:group];
        }
    }
    
    if (!_isFormPublish) {
        
        CityArea *ca = [[CityArea alloc] init];
        ca.name = NSLocalizedString(@"quanbu", nil);
        ca.id = [NSNumber numberWithInt:0];
        
        CityAreaGroup *group = [tempArray firstObject];
        if ([group.groupTitle isEqualToString:@"#"]) {
            [group.cityAreaArr insertObject:ca atIndex:0];
            [tempArray replaceObjectAtIndex:0 withObject:group];
            
        } else {
            CityAreaGroup *allGroup = [[CityAreaGroup alloc] init];
            allGroup.groupTitle = @"#";
            allGroup.cityAreaArr = [[NSMutableArray alloc] initWithObjects:ca, nil];
            [tempArray insertObject:allGroup atIndex:0];
            
            [sectionIndexs insertObject:allGroup.groupTitle atIndex:0];
        }
    }

    array = tempArray;
    [self.tableView reloadData];
    
}





#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    CityAreaGroup *group = array[section];
    return group.cityAreaArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"CityAreaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CustomCellIdentifier];
    }
    
    cell.textLabel.textColor = COL1;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.detailTextLabel.textColor = COL2;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    CityAreaGroup *group = array[indexPath.section];
    CityArea *ca = group.cityAreaArr[indexPath.row];
    
    cell.textLabel.text = ca.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
/**
 *   右侧的索引标题数组
 *
 *   @param tableView 标示图
 *
 *   @return 数组
 */
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return sectionIndexs;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityAreaGroup *group = array[indexPath.section];
    CityArea *ca = group.cityAreaArr[indexPath.row];
    
    NSLog(@"选择了地区：%@", ca.name);
    
    if (self.handler) {
        self.handler(ca);
    }
    [self leftBtnOnTouch:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CityAreaGroup *group = array[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 30)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEVICE_Width-40, 30)];
    label.text = group.groupTitle;
    label.font = [UIFont systemFontOfSize:15.0];
    [bgView addSubview:label];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}



#pragma mark - 设置 tableViewcell横线左对齐
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -

@end
