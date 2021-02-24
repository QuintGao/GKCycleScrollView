//
//  GKCycleScrollView.h
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKCycleScrollViewCell.h"

// 滚动方向
typedef NS_ENUM(NSUInteger, GKCycleScrollViewScrollDirection) {
    GKCycleScrollViewScrollDirectionHorizontal = 0, // 横向
    GKCycleScrollViewScrollDirectionVertical   = 1  // 纵向
};

@class GKCycleScrollView;

/// 数据源代理
@protocol GKCycleScrollViewDataSource <NSObject>

/// 返回cell个数
/// @param cycleScrollView cycleScrollView description
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

/// 返回继承自GKCycleScrollViewCell的类
/// @param cycleScrollView cycleScrollView description
/// @param index 索引
- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index;

@end

@protocol GKCycleScrollViewDelegate <NSObject>

@optional
/// 返回自定义cell尺寸
/// @param cycleScrollView cycleScrollView description
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

// cell滑动时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index;

// cell点击时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index;

/// scrollView滚动中的回调
/// @param cycleScrollView cycleScrollView对象
/// @param fromIndex 正在滚动中，相对位置处于左边或上边的index，根据direction区分
/// @param toIndex 正在滚动中，相对位置处于右边或下边的index，根据direction区分
/// @param ratio 从左到右或从上到下计算的百分比，根据direction区分
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView scrollingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex ratio:(CGFloat)ratio;
#pragma mark - UIScrollViewDelegate 相关
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScroll:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndScrollingAnimation:(UIScrollView *)scrollView;

@end

@interface GKCycleScrollView : UIView

// 数据源
@property (nonatomic, weak) id<GKCycleScrollViewDataSource> dataSource;
// 代理
@property (nonatomic, weak) id<GKCycleScrollViewDelegate> delegate;

// 滚动方向，默认为横向
@property (nonatomic, assign) GKCycleScrollViewScrollDirection  direction;

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 外部传入，自行处理
@property (nonatomic, weak) UIPageControl *pageControl;

// 当前展示的cell
@property (nonatomic, strong, readonly) GKCycleScrollViewCell *currentCell;

// 当前显示的页码
@property (nonatomic, assign, readonly) NSInteger   currentSelectIndex;

// 默认选中的页码（默认：0）
@property (nonatomic, assign) NSInteger defaultSelectIndex;

// 是否自动滚动，默认YES
@property (nonatomic, assign) BOOL isAutoScroll;

// 是否无限循环，默认YES
@property (nonatomic, assign) BOOL isInfiniteLoop;

// 是否改变透明度，默认YES
@property (nonatomic, assign) BOOL isChangeAlpha;

// 非当前页cell的最小透明度，默认1.0f
@property (nonatomic, assign) CGFloat minimumCellAlpha;

// 左右间距，默认0
@property (nonatomic, assign) CGFloat leftRightMargin;

// 上下间距，默认0
@property (nonatomic, assign) CGFloat topBottomMargin;

// 自动滚动时间间隔，默认3s
@property (nonatomic, assign) CGFloat autoScrollTime;

/**
 刷新数据，必须调用此方法
 */
- (void)reloadData;

/**
 获取可重复使用的cell

 @return cell
 */
- (GKCycleScrollViewCell *)dequeueReusableCell;

/**
 滑动到指定cell

 @param index 指定cell的索引
 @param animated 是否动画
 */
- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 调整当前显示的cell的位置，防止出现滚动时卡住一半
 */
- (void)adjustCurrentCell;

/**
 开启定时器
 */
- (void)startTimer;

/**
 关闭定时器
 */
- (void)stopTimer;

@end
