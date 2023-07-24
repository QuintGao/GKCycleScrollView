//
//  GKCycleScrollView.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKCycleScrollView.h"

@interface GKCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) GKCycleScrollViewCell *currentCell;

@property (nonatomic, assign, readwrite) NSInteger currentSelectIndex;

// 实际的个数
@property (nonatomic, assign) NSInteger realCount;

// 显示的个数
@property (nonatomic, assign) NSInteger showCount;

// 定时器
@property (nonatomic, weak) NSTimer     *timer;
@property (nonatomic, assign) NSInteger timerIndex;

// 当前显示的cell大小
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) NSMutableArray *reusableCells;
@property (nonatomic, assign) NSRange        visibleRange;

// 处理xib加载时导致的尺寸不准确问题
@property (nonatomic, assign) CGSize        originSize;

@end

@implementation GKCycleScrollView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(self.originSize, CGSizeZero)) return;
    
    // 解决xib加载时导致的布局错误问题
    if (!CGSizeEqualToSize(self.bounds.size, self.originSize)) {
        [self updateScrollViewAndCellSize];
    }
}

// 解决当父视图释放时，当前视图因为NSTimer强引用而导致的不能释放
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

- (void)dealloc {
    [self stopTimer];
    self.scrollView.delegate = nil;
}

// 重新此方法是为了解决当cell超出UIScrollView时不能点击的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        // 判断点击的点是否在cell上
        for (UIView *cell in self.scrollView.subviews) {
            // 将cell的frame转换到当前视图上
            CGRect convertFrame = CGRectZero;
            convertFrame.size = cell.frame.size;
            
            if (self.direction == GKCycleScrollViewScrollDirectionHorizontal) {
                convertFrame.origin.x = cell.frame.origin.x + self.scrollView.frame.origin.x - self.scrollView.contentOffset.x;
                convertFrame.origin.y = self.scrollView.frame.origin.y + cell.frame.origin.y;
            }else {
                convertFrame.origin.x = self.scrollView.frame.origin.x + cell.frame.origin.x;
                convertFrame.origin.y = cell.frame.origin.y + self.scrollView.frame.origin.y - self.scrollView.contentOffset.y;
            }

            // 判断点击的点是否在cell上
            if (CGRectContainsPoint(convertFrame, point)) {
                // 修复cell上添加其他点击事件无效的bug
                UIView *view = [super hitTest:point withEvent:event];
                if (view == self || view == cell || view == self.scrollView) return cell;
                return view;
            }
        }
        // 判断点击的点是否在UIScrollView上
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x;
        newPoint.y = point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y;
        if ([self.scrollView pointInside:newPoint withEvent:event]) {
            return [self.scrollView hitTest:newPoint withEvent:event];
        }
        // 系统处理
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

#pragma mark - Public Methods
- (void)reloadData {
    // 移除所有cell
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 停止定时器
    [self stopTimer];
    
    // 加载数据
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellsInCycleScrollView:)]) {
        // 实际个数
        self.realCount = [self.dataSource numberOfCellsInCycleScrollView:self];
        
        // 展示个数
        if (self.isInfiniteLoop) {
            self.showCount = self.realCount == 1 ? 1 : self.realCount * 3;
        }else {
            self.showCount = self.realCount;
        }
        
        // 如果总页数为0，return
        if (self.showCount == 0) return;
        
        if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
            [self.pageControl setNumberOfPages:self.realCount];
        }
    }
    
    // 清除原始数据
    [self.visibleCells removeAllObjects];
    [self.reusableCells removeAllObjects];
    self.visibleRange = NSMakeRange(0, 0);
    
    //cell数量为1或defaultSelectIndex超过了当前数量
    if(self.defaultSelectIndex >= self.realCount) {
        self.defaultSelectIndex = 0;
    }
    if(self.realCount == 1) {
        self.timerIndex = 0;
    }
    
    for (NSInteger i = 0; i < self.showCount; i++){
        [self.visibleCells addObject:[NSNull null]];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSizeCompletion:^{
        [weakSelf initialScrollViewAndCellSize];
    }];
}

- (void)refreshSizeCompletion:(void(^)(void))completion {
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        [self layoutIfNeeded];
        // 此处做延时处理是为了解决使用Masonry布局时导致的view的大小不能及时更新的bug
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
                [self refreshSizeCompletion:completion];
            }else {
                !completion ? : completion();
            }
        });
    }else {
        !completion ? : completion();
    }
}

- (GKCycleScrollViewCell *)dequeueReusableCell{
    GKCycleScrollViewCell *cell = self.reusableCells.lastObject;
    if (cell) {
        [self.reusableCells removeLastObject];
    }
    return cell;
}

- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < self.realCount) {
        [self stopTimer];
        
        if (self.isInfiniteLoop) {
            self.timerIndex = self.realCount + index;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startTimer) object:nil];
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.5];
        } else {
            self.timerIndex = index;
        }
        
        switch (self.direction) {
            case GKCycleScrollViewScrollDirectionHorizontal:
                [self.scrollView setContentOffset:CGPointMake(self.cellSize.width * self.timerIndex, 0) animated:animated];
                break;
            case GKCycleScrollViewScrollDirectionVertical:
                [self.scrollView setContentOffset:CGPointMake(0, self.cellSize.height * self.timerIndex) animated:animated];
                break;
            default:
                break;
        }
        [self setupCellsWithContentOffset:self.scrollView.contentOffset];
        [self updateVisibleCellAppearance];
    }
}

- (void)adjustCurrentCell {
    if (self.isAutoScroll && self.realCount > 0) {
        switch (self.direction) {
            case GKCycleScrollViewScrollDirectionHorizontal: {
                self.scrollView.contentOffset = CGPointMake(self.cellSize.width * self.timerIndex, 0);
            }
                break;
            case GKCycleScrollViewScrollDirectionVertical: {
                self.scrollView.contentOffset = CGPointMake(0, self.cellSize.height * self.timerIndex);
            }
                break;
            default:
                break;
        }
    }
}

- (void)startTimer {
    if (self.realCount > 1 && self.isAutoScroll) {
        [self stopTimer];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark Private Methods
- (void)initialization {
    // 初始化默认数据
    self.clipsToBounds      = YES;
    self.isChangeAlpha      = YES;
    self.isAutoScroll       = YES;
    self.isInfiniteLoop     = YES;
    self.minimumCellAlpha   = 1.0f;
    self.autoScrollTime     = 3.0f;
    
    // 添加scrollView
    [self addSubview:self.scrollView];
}

- (void)initialScrollViewAndCellSize {
    self.originSize = self.bounds.size;
    [self updateScrollViewAndCellSize];
    
    // 默认选中
    if (self.defaultSelectIndex >= 0 && self.defaultSelectIndex < self.realCount) {
        [self handleCellScrollWithIndex:self.defaultSelectIndex];
    }
}

- (void)updateScrollViewAndCellSize {
    if (self.bounds.size.width <= 0 || self.bounds.size.height <= 0) return;
    
    // 设置cell尺寸
    self.cellSize = CGSizeMake(self.bounds.size.width - 2 * self.leftRightMargin, self.bounds.size.height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForCellInCycleScrollView:)]) {
        self.cellSize = [self.delegate sizeForCellInCycleScrollView:self];
    }
    
    // 设置scrollView大小
    switch (self.direction) {
        case GKCycleScrollViewScrollDirectionHorizontal: {
            self.scrollView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
            self.scrollView.contentSize = CGSizeMake(self.cellSize.width * self.showCount,0);
            self.scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            
            if (self.realCount > 1) {
                CGPoint offset = CGPointZero;
                
                if (self.isInfiniteLoop) { // 开启无限轮播
                    // 滚动到第二组
                    offset = CGPointMake(self.cellSize.width * (self.realCount + self.defaultSelectIndex), 0);
                    self.timerIndex = self.realCount + self.defaultSelectIndex;
                }else {
                    offset = CGPointMake(self.cellSize.width * self.defaultSelectIndex, 0);
                    self.timerIndex = self.defaultSelectIndex;
                }
                
                [self.scrollView setContentOffset:offset animated:NO];
                
                // 自动轮播
                if (self.isAutoScroll) {
                    [self startTimer];
                }
            }
        }
            break;
        case GKCycleScrollViewScrollDirectionVertical: {
            self.scrollView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
            self.scrollView.contentSize = CGSizeMake(0, self.cellSize.height * self.showCount);
            self.scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            
            if (self.realCount > 1) {
                CGPoint offset = CGPointZero;
                if (self.isInfiniteLoop) { // 开启无限轮播
                    // 滚动到第二组
                    offset = CGPointMake(0, self.cellSize.height * (self.realCount + self.defaultSelectIndex));
                    self.timerIndex = self.realCount + self.defaultSelectIndex;
                }else {
                    offset = CGPointMake(0, self.cellSize.height * self.defaultSelectIndex);
                    self.timerIndex = self.defaultSelectIndex;
                }
                
                [self.scrollView setContentOffset:offset animated:NO];
                
                // 自动轮播
                if (self.isAutoScroll) {
                    [self startTimer];
                }
            }
        }
            break;
        default:
            break;
    }
    
    // 根据当前scrollView的offset设置显示的cell
    [self setupCellsWithContentOffset:self.scrollView.contentOffset];
    
    // 更新可见cell的显示
    [self updateVisibleCellAppearance];
}

- (void)setupCellsWithContentOffset:(CGPoint)offset {
    if (self.showCount == 0) return;
    if (self.cellSize.width <= 0 || self.cellSize.height <= 0) return;
    //计算_visibleRange
    CGFloat originX = self.scrollView.frame.origin.x == 0 ? 0.01 : self.scrollView.frame.origin.x;
    CGFloat originY = self.scrollView.frame.origin.y == 0 ? 0.01 : self.scrollView.frame.origin.y;
    
    CGPoint startPoint = CGPointMake(offset.x - originX, offset.y - originY);
    CGPoint endPoint = CGPointMake(offset.x + self.scrollView.frame.size.width + originX, offset.y + self.scrollView.frame.size.height + originY);
    
    switch (self.direction) {
        case GKCycleScrollViewScrollDirectionHorizontal: {
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < self.visibleCells.count; i++) {
                if (self.cellSize.width * (i + 1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < self.visibleCells.count; i++) {
                //如果都不超过则取最后一个
                if ((self.cellSize.width * (i + 1) < endPoint.x && self.cellSize.width * (i + 2) >= endPoint.x) || i + 2 == self.visibleCells.count) {
                    endIndex = i + 1;
                    break;
                }
            }
            
            // 可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex, 0);
            endIndex = MIN(endIndex, self.visibleCells.count - 1);
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self addCellAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < self.visibleCells.count; i ++) {
                [self removeCellAtIndex:i];
            }
        }
            break;
        case GKCycleScrollViewScrollDirectionVertical: {
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < self.visibleCells.count; i++) {
                if (self.cellSize.height * (i +1) > startPoint.y) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < self.visibleCells.count; i++) {
                //如果都不超过则取最后一个
                if ((self.cellSize.height * (i + 1) < endPoint.y && self.cellSize.height * (i + 2) >= endPoint.y) || i+ 2 == self.visibleCells.count) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
            
            //可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, self.visibleCells.count - 1);
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self addCellAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < self.visibleCells.count; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        default:
            break;
    }
}

- (void)updateVisibleCellAppearance {
    if (self.showCount == 0) return;
    if (self.cellSize.width <= 0 || self.cellSize.height <= 0) return;
    
    switch (self.direction) {
        case GKCycleScrollViewScrollDirectionHorizontal:{
            CGFloat offsetX = self.scrollView.contentOffset.x;
            for (NSInteger i = self.visibleRange.location; i < NSMaxRange(self.visibleRange); i++) {
                GKCycleScrollViewCell *cell = self.visibleCells[i];
                CGFloat originX = cell.frame.origin.x;
                CGFloat delta = fabs(originX - offsetX);
                
                CGRect originCellFrame = (CGRect){{self.cellSize.width * i, 0}, self.cellSize};
                
                CGFloat leftRightInset = 0;
                CGFloat topBottomInset = 0;
                CGFloat alpha = 0;
                
                if (delta < self.cellSize.width) {
                    alpha = (delta / self.cellSize.width) * self.minimumCellAlpha;
                    
                    CGFloat adjustLeftRightMargin = self.leftRightMargin == 0 ? 0 : self.leftRightMargin + 1;
                    CGFloat adjustTopBottomMargin = self.topBottomMargin == 0 ? 0 : self.topBottomMargin;
                    
                    leftRightInset = adjustLeftRightMargin * delta / self.cellSize.width;
                    topBottomInset = adjustTopBottomMargin * delta / self.cellSize.width;
                    
                    NSInteger index = self.realCount == 0 ? 0 : i % self.realCount;
                    if (index == self.currentSelectIndex) {
                        [self.scrollView bringSubviewToFront:cell];
                    }
                } else {
                    alpha = self.minimumCellAlpha;
                    
                    leftRightInset = self.leftRightMargin;
                    topBottomInset = self.topBottomMargin;
                    
                    [self.scrollView sendSubviewToBack:cell];
                }
                
                if (self.leftRightMargin == 0 && self.topBottomMargin == 0) {
                    cell.frame = originCellFrame;
                }else {
                    CGFloat scaleX = (self.cellSize.width - leftRightInset * 2) / self.cellSize.width;
                    CGFloat scaleY = (self.cellSize.height - topBottomInset * 2) / self.cellSize.height;
                    UIEdgeInsets insets = UIEdgeInsetsMake(topBottomInset, leftRightInset - 0.1, topBottomInset, leftRightInset);
                    
                    cell.layer.transform = CATransform3DMakeScale(scaleX, scaleY, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, insets);
                }
                
                // 获取当前cell
                if (cell.tag == self.currentSelectIndex) {
                    self.currentCell = cell;
                }
                
                // 透明度渐变
                if (self.isChangeAlpha) {
                    cell.coverView.alpha = alpha;
                }
            }
        }
            break;
        case GKCycleScrollViewScrollDirectionVertical:{
            CGFloat offsetY = self.scrollView.contentOffset.y;
            for (NSInteger i = self.visibleRange.location; i < NSMaxRange(self.visibleRange); i++) {
                GKCycleScrollViewCell *cell = self.visibleCells[i];
                CGFloat originY = cell.frame.origin.y;
                CGFloat delta = fabs(originY - offsetY);
                
                CGRect originCellFrame = (CGRect){{0, self.cellSize.height * i}, self.cellSize};
                
                CGFloat leftRightInset = 0;
                CGFloat topBottomInset = 0;
                CGFloat alpha = 0;
                
                if (delta < self.cellSize.height) {
                    alpha = (delta / self.cellSize.height) * self.minimumCellAlpha;
                    
                    CGFloat adjustLeftRightMargin = self.leftRightMargin == 0 ? 0 : self.leftRightMargin;
                    CGFloat adjustTopBottomMargin = self.topBottomMargin == 0 ? 0 : self.topBottomMargin + 1;
                    
                    leftRightInset = adjustLeftRightMargin * delta / self.cellSize.height;
                    topBottomInset = adjustTopBottomMargin * delta / self.cellSize.height;
                    
                    NSInteger index = self.realCount == 0 ? 0 : i % self.realCount;
                    if (index == self.currentSelectIndex) {
                        [self.scrollView bringSubviewToFront:cell];
                    }
                } else {
                    alpha = self.minimumCellAlpha;
                    
                    leftRightInset = self.leftRightMargin;
                    topBottomInset = self.topBottomMargin;
                    
                    [self.scrollView sendSubviewToBack:cell];
                }
                
                if (self.leftRightMargin == 0 && self.topBottomMargin == 0) {
                    cell.frame = originCellFrame;
                }else {
                    CGFloat scaleX = (self.cellSize.width - leftRightInset * 2) / self.cellSize.width;
                    CGFloat scaleY = (self.cellSize.height - topBottomInset * 2) / self.cellSize.height;
                    UIEdgeInsets insets = UIEdgeInsetsMake(topBottomInset - 0.1, leftRightInset, topBottomInset, leftRightInset);
                    
                    cell.layer.transform = CATransform3DMakeScale(scaleX, scaleY, 1.0f);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, insets);
                }
                
                // 透明度渐变
                if (self.isChangeAlpha) {
                    cell.coverView.alpha = alpha;
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)addCellAtIndex:(NSInteger)index {
    NSParameterAssert(index >= 0 && index < self.visibleCells.count);
    
    GKCycleScrollViewCell *cell = self.visibleCells[index];
    if ((NSObject *)cell == [NSNull null]) {
        cell = [self.dataSource cycleScrollView:self cellForViewAtIndex:index % self.realCount];
        if (cell) {
            [self.visibleCells replaceObjectAtIndex:index withObject:cell];
            
            cell.tag = index % self.realCount;
            [cell setupCellFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
            if (!self.isChangeAlpha) cell.coverView.hidden = YES;
            
            __weak __typeof(self) weakSelf = self;
            cell.didCellClick = ^(NSInteger index) {
                [weakSelf handleCellSelectWithIndex:index];
            };
            
            switch (self.direction) {
                case GKCycleScrollViewScrollDirectionHorizontal:
                    cell.frame = CGRectMake(self.cellSize.width * index, 0, self.cellSize.width, self.cellSize.height);
                    break;
                case GKCycleScrollViewScrollDirectionVertical:
                    cell.frame = CGRectMake(0, self.cellSize.height * index, self.cellSize.width, self.cellSize.height);
                    break;
                default:
                    break;
            }
            
            if (!cell.superview) {
                [self.scrollView addSubview:cell];
            }
        }
    }
}

- (void)removeCellAtIndex:(NSInteger)index{
    GKCycleScrollViewCell *cell = [self.visibleCells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) return;
    
    [self.reusableCells addObject:cell];
    
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    
    [self.visibleCells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)handleCellSelectWithIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectCellAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectCellAtIndex:index];
    }
}

- (void)handleCellScrollWithIndex:(NSInteger)index {
    self.currentSelectIndex = index;
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        self.pageControl.currentPage = index;
    }
    
    // 获取当前cell
    for (NSInteger i = self.visibleRange.location; i < NSMaxRange(self.visibleRange); i++) {
        GKCycleScrollViewCell *cell = self.visibleCells[i];
        if (cell.tag == index) {
            self.currentCell = cell;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollCellToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollCellToIndex:index];
    }
}

- (void)timerUpdate {
    self.timerIndex++;
    
    // bug fixed：解决反向滑动停止后，可能出现的自动滚动错乱问题
    if (self.timerIndex > self.realCount * 2) {
        self.timerIndex = self.realCount * 2;
    }
    
    if (!self.isInfiniteLoop) {
        if (self.timerIndex >= self.realCount) {
            self.timerIndex = 0;
        }
    }
    
    switch (self.direction) {
        case GKCycleScrollViewScrollDirectionHorizontal: {
            [self.scrollView setContentOffset:CGPointMake(self.cellSize.width * self.timerIndex, 0) animated:YES];
        }
            break;
        case GKCycleScrollViewScrollDirectionVertical: {
            [self.scrollView setContentOffset:CGPointMake(0, self.cellSize.height * self.timerIndex) animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.realCount == 0) return;
    if (self.cellSize.width <= 0 || self.cellSize.height <= 0) return;
    
    NSInteger index = 0;
    switch (self.direction) {
        case GKCycleScrollViewScrollDirectionHorizontal: {
            index = (NSInteger)round(self.scrollView.contentOffset.x / self.cellSize.width) % self.realCount;
        }
            break;
        case GKCycleScrollViewScrollDirectionVertical: {
            index = (NSInteger)round(self.scrollView.contentOffset.y / self.cellSize.height) % self.realCount;
        }
            break;
        default:
            break;
    }
    
    if (self.isInfiniteLoop) {
        if (self.realCount > 1) {
            switch (self.direction) {
                case GKCycleScrollViewScrollDirectionHorizontal: {
                    CGFloat horIndex = scrollView.contentOffset.x / self.cellSize.width;
                    if (horIndex >= 2 * self.realCount) {
                        scrollView.contentOffset = CGPointMake(self.cellSize.width * self.realCount, 0);
                        self.timerIndex = self.realCount;
                    }
                    
                    if (horIndex <= (self.realCount - 1)) {
                        scrollView.contentOffset = CGPointMake(self.cellSize.width * (2 * self.realCount - 1), 0);
                        self.timerIndex = 2 * self.realCount - 1;
                    }
                }
                    break;
                case GKCycleScrollViewScrollDirectionVertical: {
                    NSInteger verIndex = scrollView.contentOffset.y / self.cellSize.height;
                    
                    if (verIndex >= 2 * self.realCount) {
                        scrollView.contentOffset = CGPointMake(0, self.cellSize.height * self.realCount);
                        self.timerIndex = self.realCount;
                    }
                    
                    if (verIndex <= (self.realCount - 1)) {
                        scrollView.contentOffset = CGPointMake(0, self.cellSize.height * (2 * self.realCount - 1));
                        self.timerIndex = 2 * self.realCount - 1;
                    }
                }
                    break;
                default:
                    break;
            }
        }else {
            index = 0;
        }
    }
    
    [self setupCellsWithContentOffset:scrollView.contentOffset];
    [self updateVisibleCellAppearance];
    
    if (index >= 0 && self.currentSelectIndex != index) {
        [self handleCellScrollWithIndex:index];
    }
    
    [self handleScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:willBeginDragging:)]) {
        [self.delegate cycleScrollView:self willBeginDragging:scrollView];
    }
}

// 结束拖拽时调用，decelerate是否有减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self startTimer];
    }
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didEndDragging:willDecelerate:)]) {
        [self.delegate cycleScrollView:self didEndDragging:scrollView willDecelerate:decelerate];
    }
}

// 结束减速是调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didEndDecelerating:)]) {
        [self.delegate cycleScrollView:self didEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.realCount > 1 && self.isAutoScroll) {
        switch (self.direction) {
            case GKCycleScrollViewScrollDirectionHorizontal: {
                NSInteger index = round(targetContentOffset->x / self.cellSize.width);
                self.timerIndex = index;
            }
                break;
            case GKCycleScrollViewScrollDirectionVertical: {
                NSInteger index = round(targetContentOffset->y / self.cellSize.height);
                self.timerIndex = index;
            }
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateVisibleCellAppearance];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didEndScrollingAnimation:)]) {
        [self.delegate cycleScrollView:self didEndScrollingAnimation:scrollView];
    }
}

- (void)handleScrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScroll:)]) {
        [self.delegate cycleScrollView:self didScroll:scrollView];
    }
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollingFromIndex:toIndex:ratio:)]) {
        BOOL isFirstRevirse = NO; // 是否在第一个位置反向滑动
        CGFloat ratio = 0;   // 滑动百分比
        if (self.direction == GKCycleScrollViewScrollDirectionHorizontal) {
            CGFloat offsetX = scrollView.contentOffset.x;
            CGFloat maxW = self.realCount * scrollView.bounds.size.width;
            
            CGFloat changeOffsetX = self.isInfiniteLoop ? (offsetX - maxW) : offsetX;
            if (changeOffsetX < 0) {
                changeOffsetX = -changeOffsetX;
                isFirstRevirse = YES;
            }
            ratio = (changeOffsetX / scrollView.bounds.size.width);
        }else if (self.direction == GKCycleScrollViewScrollDirectionVertical) {
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat maxW = self.realCount * scrollView.bounds.size.height;
            
            CGFloat changeOffsetY = self.isInfiniteLoop ? (offsetY - maxW) : offsetY;
            if (changeOffsetY < 0) {
                changeOffsetY = -changeOffsetY;
                isFirstRevirse = YES;
            }
            ratio = (changeOffsetY / scrollView.bounds.size.height);
        }
        if (ratio > self.realCount || ratio < 0) return; // 越界，不作处理
        ratio = MAX(0, MIN(self.realCount, ratio));
        NSInteger baseIndex = floor(ratio);
        if (baseIndex + 1 > self.realCount) {
            // 右边越界了
            baseIndex = 0;
        }
        CGFloat remainderRatio = ratio - baseIndex;
        if (remainderRatio <= 0 || remainderRatio >= 1) return;
        NSInteger toIndex = 0;
        if (isFirstRevirse) {
            baseIndex = self.realCount - 1;
            toIndex = 0;
            remainderRatio = 1 - remainderRatio;
        }else if (baseIndex == self.realCount - 1) {
            toIndex = 0;
        }else {
            toIndex = baseIndex + 1;
        }
        [self.delegate cycleScrollView:self scrollingFromIndex:baseIndex toIndex:toIndex ratio:remainderRatio];
    }
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)visibleCells {
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray new];
    }
    return _visibleCells;
}

- (NSMutableArray *)reusableCells {
    if (!_reusableCells) {
        _reusableCells = [NSMutableArray new];
    }
    return _reusableCells;
}

@end
