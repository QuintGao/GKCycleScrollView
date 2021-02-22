//
//  GKDemo003ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/18.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo003ViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import <SDWebImage/SDWebImage.h>

@interface GKDemo003ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) NSArray               *dataArr;

@property (nonatomic, strong) JXCategoryTitleView   *categoryView;

@property (nonatomic, strong) GKCycleScrollView     *cycleScrollView;

@property (nonatomic, strong) GKPageControl         *pageControl;

@property (nonatomic, assign) BOOL                  isClickCategory;
@property (nonatomic, assign) BOOL                  isSelectCategory;

@end

@implementation GKDemo003ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@{@"title": @"美女", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2Fmn01%2F022219204249%2F1Z222204249-7.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1616574225&t=6823cf729e389877cbdec6b6cf6f3318"},
                     @{@"title": @"唯美", @"img_url": @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2662286432,3722176444&fm=15&gp=0.jpg"},
                     @{@"title": @"可爱", @"img_url": @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1361252553,2794528335&fm=26&gp=0.jpg"},
                     @{@"title": @"简约", @"img_url": @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2379750824,3935342609&fm=26&gp=0.jpg"},
                     @{@"title": @"科幻", @"img_url": @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1806438408,1904034154&fm=15&gp=0.jpg"},
                     @{@"title": @"星座", @"img_url": @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1372360933,3806396369&fm=15&gp=0.jpg"},
                     @{@"title": @"时尚", @"img_url": @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1399835155,3191540966&fm=26&gp=0.jpg"},
                     @{@"title": @"萌宠", @"img_url": @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1401886252,3397293517&fm=15&gp=0.jpg"}];
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.cycleScrollView];
    [self.view addSubview:self.pageControl];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.gk_navigationBar.mas_bottom);
        make.height.mas_equalTo(kAdapter(100.0f));
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom).offset(kAdapter(20.0f));
        make.height.mas_equalTo(kAdapter(850.0f));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(kAdapter(36.0f));
        make.height.mas_equalTo(kAdapter(12.0f));
    }];
    
    NSMutableArray *titles = [NSMutableArray new];
    [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:dict[@"title"]];
    }];
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
    
    [self.cycleScrollView reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.layer.cornerRadius = kAdapter(10.0f);
        cell.layer.masksToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    NSDictionary *dict = self.dataArr[index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(ceilf(kAdapter(560.0f)), kAdapter(850.0f));
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    if (self.isClickCategory) return;
    
//    self.isSelectCategory = YES;
//    [self.categoryView selectCellAtIndex:index selectedType:JXCategoryCellSelectedTypeScroll];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.isSelectCategory = NO;
//    });
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.isSelectCategory) return;
    
    self.isClickCategory = YES;
    [self.cycleScrollView scrollToCellAtIndex:index animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isClickCategory = NO;
        [self.cycleScrollView startTimer];
    });
    
}

#pragma mark - 懒加载
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [JXCategoryTitleView new];
        _categoryView.titleFont = [UIFont systemFontOfSize:14.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:14.0f];
        _categoryView.titleColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0];
        _categoryView.titleSelectedColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
        _categoryView.delegate = self;
        
        JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
        lineView.indicatorColor = [UIColor colorWithRed:254/255.0 green:89/255.0 blue:93/255.0 alpha:1.0];
        lineView.indicatorWidth = kAdapter(40.0f);
        lineView.indicatorHeight = kAdapter(4.0f);
        lineView.verticalMargin = kAdapter(25.0f);
        _categoryView.indicators = @[lineView];
        
        _categoryView.contentScrollView = self.cycleScrollView.scrollView;
    }
    return _categoryView;
}

- (GKCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [GKCycleScrollView new];
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
//        _cycleScrollView.isAutoScroll = NO;
        _cycleScrollView.isInfiniteLoop = NO;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.leftRightMargin = kAdapter(50.0f);
        _cycleScrollView.topBottomMargin = kAdapter(40.0f);
        _cycleScrollView.pageControl = self.pageControl;
    }
    return _cycleScrollView;
}

- (GKPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [GKPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:254/255.0 green:89/255.0 blue:93/255.0 alpha:1.0];
    }
    return _pageControl;
}

@end
