//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";
//NSLocalizedString(<#key#>, <#comment#>)

//static NSString * MJRefreshHeaderIdleText = @"下拉可以刷新";
//NSString *const MJRefreshHeaderPullingText = @"松开立即刷新";
//NSString *const MJRefreshHeaderRefreshingText = @"正在刷新数据中...";
//
//NSString *const MJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
//NSString *const MJRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
//NSString *const MJRefreshAutoFooterNoMoreDataText = @"我是有底线的";
//
//NSString *const MJRefreshBackFooterIdleText = @"上拉可以加载更多";
//NSString *const MJRefreshBackFooterPullingText = @"松开立即加载更多";
//NSString *const MJRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
//NSString *const MJRefreshBackFooterNoMoreDataText = @"我是有底线的";


//"zhelikongkongruye" = "这里空空如也";
//"wangluozoudiule" = "网络走丢啦";
//"xialakeyishuaxin" = "下拉可以刷新";
//"songkailijishuaxin" = "松开立即刷新";
//"zhengzaishuaxsjzhong" = "正在刷新数据中...";
//"dianjihuoshanglajzgd" = "点击或上拉加载更多";
//"zhengzaijiazaigdsj" = "正在加载更多的数据...";
//"woshiyoudixiande" = "我是有底线的";
//"shanglakyjiazaigd" = "上拉可以加载更多的";
//"songkailijijiazgd" = "松开立即加载更多";
//"zhengzaijiazaigengduosj" = "正在加载更多的数据...";
