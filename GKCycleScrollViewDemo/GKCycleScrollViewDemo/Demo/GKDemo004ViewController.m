//
//  GKDemo004ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/23.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo004ViewController.h"
#import "GKCycleScrollView.h"
#import <JXCategoryView/JXCategoryView.h>

@interface GKDemo004ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;

@property (nonatomic, strong) JXCategoryImageView *categoryView;
@property (nonatomic, strong) GKCycleScrollView *iconScrollView;

@end

@implementation GKDemo004ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.cycleScrollView];
    [self.view addSubview:self.categoryView];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(kAdapter(990.0f));
    }];
    
    [self.cycleScrollView reloadData];
    
//    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(kAdapter(30.0f));
//        make.height.mas_equalTo(kAdapter(84.0f));
//    }];
    [self.view addSubview:self.iconScrollView];
    [self.iconScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(kAdapter(30.0f));
        make.height.mas_equalTo(kAdapter(84.0f));
    }];
    
    [self.iconScrollView reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return 7;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
    }
    if (cycleScrollView == self.cycleScrollView) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"demo00%zd", index + 1]];
    }else if (cycleScrollView == self.iconScrollView) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon00%zd", index + 1]];
        cell.layer.cornerRadius = kAdapter(42.0f);
        cell.layer.masksToBounds = YES;
    }
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    if (cycleScrollView == self.cycleScrollView) {
        return CGSizeMake(kAdapter(560.0f), kAdapter(990.0f));
    }else if (cycleScrollView == self.iconScrollView) {
        return CGSizeMake(kAdapter(84.0f), kAdapter(84.0f));
    }
    return CGSizeZero;
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    if (cycleScrollView == self.cycleScrollView) {
        [self.iconScrollView scrollToCellAtIndex:index animated:YES];
    }else if (cycleScrollView == self.iconScrollView) {
        [self.cycleScrollView scrollToCellAtIndex:index animated:YES];
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    if (cycleScrollView == self.iconScrollView) {
        [self.cycleScrollView scrollToCellAtIndex:index animated:YES];
    }
}

#pragma mark - 懒加载
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

- (GKCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [GKCycleScrollView new];
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.isAutoScroll = NO;
        _cycleScrollView.isInfiniteLoop = NO;
        _cycleScrollView.leftRightMargin = -kAdapter(10.0f);
        _cycleScrollView.topBottomMargin = kAdapter(30.0f);
    }
    return _cycleScrollView;
}

- (JXCategoryImageView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryImageView alloc] init];
        
        NSMutableArray *imgNames = [NSMutableArray new];
        for (NSInteger i = 0; i < 7; i++) {
            [imgNames addObject:[NSString stringWithFormat:@"icon00%zd", i + 1]];
        }
        _categoryView.imageNames = imgNames;
        _categoryView.selectedImageNames = imgNames;
        _categoryView.imageZoomEnabled = YES;
        _categoryView.imageSize = CGSizeMake(kAdapter(68.0f), kAdapter(68.0f));
        _categoryView.imageCornerRadius = kAdapter(34.0f);
        _categoryView.contentEdgeInsetLeft = kAdapter(100.0f);
        _categoryView.contentEdgeInsetRight = kAdapter(540.0f);
    }
    return _categoryView;
}

- (GKCycleScrollView *)iconScrollView {
    if (!_iconScrollView) {
        _iconScrollView = [GKCycleScrollView new];
        _iconScrollView.dataSource = self;
        _iconScrollView.delegate = self;
        _iconScrollView.isChangeAlpha = NO;
        _iconScrollView.isAutoScroll = NO;
        _iconScrollView.isInfiniteLoop = NO;
        _iconScrollView.leftRightMargin = kAdapter(10.0f);
        _iconScrollView.topBottomMargin = kAdapter(10.0f);
    }
    return _iconScrollView;
}

@end
