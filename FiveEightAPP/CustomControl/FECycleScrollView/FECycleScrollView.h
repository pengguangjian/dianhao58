//
//  FECycleScrollView.h
//  FiveEightAPP
//
//  Created by caochun on 2019/9/12.
//  Copyright © 2019年 DianHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FECycleScrollView;

@compatibility_alias FECycleScrollViewCell UICollectionViewCell;

typedef NS_ENUM(NSInteger, FEScrollDirection) {
    FEScrollDirectionHorizontal = 0,
    FEScrollDirectionVertical
};

@protocol FECycleScrollViewDataSource <NSObject>

// Return number of pages
- (NSInteger)numberOfItemsInCycleScrollView:(FECycleScrollView *)cycleScrollView;
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndex:
- (__kindof FECycleScrollViewCell *)cycleScrollView:(FECycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index;

@end

@protocol FECycleScrollViewDelegate <NSObject>

@optional
// Called when the cell is clicked
- (void)cycleScrollView:(FECycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
// Called when the offset changes. The progress range is from 0 to the maximum index value, which means the progress value for a round of scrolling
- (void)cycleScrollViewDidScroll:(FECycleScrollView *)cycleScrollView progress:(CGFloat)progress;
// Called when scrolling to a new index page
- (void)cycleScrollView:(FECycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

IB_DESIGNABLE
@interface  FECycleScrollView : UIView

@property (nullable, nonatomic, weak) IBOutlet id<FECycleScrollViewDelegate> delegate;
@property (nullable, nonatomic, weak) IBOutlet id<FECycleScrollViewDataSource> dataSource;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger scrollDirection;
@property (nonatomic, assign) IBInspectable double autoScrollInterval;
#else
@property (nonatomic, assign) FEScrollDirection scrollDirection; // default horizontal. scroll direction
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; // default 3.f. automatic scroll time interval
#endif

@property (nonatomic, assign) IBInspectable BOOL autoScroll; // default YES
@property (nonatomic, assign) IBInspectable BOOL allowsDragging; // default YES. turn off any dragging temporarily

@property (nonatomic, assign) IBInspectable CGSize  itemSize; // default the view size
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing; // default 0.f
@property (nonatomic, assign) IBInspectable CGFloat itemZoomScale; // default 1.f(no scaling), it ranges from 0.f to 1.f

@property (nonatomic, assign) IBInspectable BOOL hidesPageControl; // default NO
@property (nullable, nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor; // default gray
@property (nullable, nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor; // default white

@property (nonatomic, readonly, assign) NSInteger pageIndex; // current page index
@property (nonatomic, readonly, assign) CGPoint contentOffset;  // current content offset

@property (nullable, nonatomic, copy) dispatch_block_t loadCompletion; // load completed callback

- (void)registerCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerCellNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof FECycleScrollViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)reloadData;
// If the cell gets stuck in half the time when you push or present a new view controller, you can call this method in the -viewWillAppear: method of the view controller where the cyclescrollView is located.
- (void)adjustWhenViewWillAppear;

@end


