//
//  GKDemo003ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/18.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo003ViewController.h"
#import <JXCategoryViewExt/JXCategoryView.h>
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
    
    self.dataArr = @[@{@"title": @"美女", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201702%2F05%2F20170205182700_dWNkf.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=08348ce43e5ccc443ad5505e04e7ca35"},
                     @{@"title": @"唯美", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201702%2F05%2F20170205181958_ZSPC3.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=d2e59ceb71607c47795f8ce1eb93f40e"},
                     @{@"title": @"可爱", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201702%2F05%2F20170205213628_dj3ic.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=f9577da4768bb8ac41fd787472c1dbaf"},
                     @{@"title": @"简约", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201702%2F05%2F20170205183201_nYz8M.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=797df1a080a903765819922a5d47fba8"},
                     @{@"title": @"科幻", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F06%2F20200306132544_iBBWt.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=c9b20cc5faae92c0bdc6e618878f8d4f"},
                     @{@"title": @"星座", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201903%2F21%2F20190321091310_5XYY3.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=1f01654c98ad15c7761510dd89a331e4"},
                     @{@"title": @"时尚", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201502%2F26%2F20150226234627_sPvPc.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=993a869cc36d66c41038145a6315790d"},
                     @{@"title": @"萌宠", @"img_url": @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F06%2F20150506220237_j3veJ.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1692753358&t=efef6c85adc6b6b3295e4543531be357"}];
    
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
    if (cycleScrollView.scrollView.isTracking) return;
    
    if (self.isClickCategory) return;
    
    self.isSelectCategory = YES;
    [self.categoryView selectCellAtIndex:index selectedType:JXCategoryCellSelectedTypeScroll];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isSelectCategory = NO;
    });
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
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
        _categoryView.selectItemOnScrollHalf = YES;
        
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
