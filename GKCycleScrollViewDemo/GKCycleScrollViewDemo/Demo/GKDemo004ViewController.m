//
//  GKDemo004ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/23.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo004ViewController.h"
#import "GKCycleScrollView.h"

@interface GKDemo004ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;

@property (nonatomic, strong) GKCycleScrollView *iconScrollView;

@property (nonatomic, strong) UIImageView       *arrowImgView;

@property (nonatomic, assign) BOOL  isSelectIcon;
@property (nonatomic, assign) BOOL  isScrollCard;
@property (nonatomic, assign) BOOL  isScrollIcon;

@end

@implementation GKDemo004ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.cycleScrollView];
    [self.view addSubview:self.arrowImgView];
    [self.view addSubview:self.iconScrollView];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(kAdapter(990.0f));
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.cycleScrollView.mas_bottom);
    }];

    [self.iconScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.arrowImgView.mas_bottom).offset(kAdapter(30.0f));
        make.height.mas_equalTo(kAdapter(84.0f));
    }];
    
    [self.cycleScrollView reloadData];
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
//    if (self.isSelectIcon) return;
//    if (cycleScrollView == self.cycleScrollView) {
//        [self.iconScrollView scrollToCellAtIndex:index animated:YES];
//    }else if (cycleScrollView == self.iconScrollView) {
//        [self.cycleScrollView scrollToCellAtIndex:index animated:YES];
//    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    if (cycleScrollView == self.iconScrollView) {
        self.isSelectIcon = YES;
        [self.iconScrollView scrollToCellAtIndex:index animated:YES];
        [self.cycleScrollView scrollToCellAtIndex:index animated:YES];
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView {
    if (cycleScrollView == self.cycleScrollView) {
        self.isScrollCard = YES;
    }else if (cycleScrollView == self.iconScrollView) {
        self.isScrollIcon = YES;
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScroll:(UIScrollView *)scrollView {
    if (cycleScrollView == self.cycleScrollView) {
        if (self.isScrollIcon) return;
        if (!self.isScrollCard) return;
        CGFloat ratio = scrollView.contentOffset.x / scrollView.contentSize.width;
        CGPoint offset = CGPointMake(self.iconScrollView.scrollView.contentSize.width * ratio, 0);
        [self.iconScrollView.scrollView setContentOffset:offset animated:NO];
    }else if (cycleScrollView == self.iconScrollView) {
        if (self.isScrollCard) return;
        if (!self.isScrollIcon) return;
        CGFloat ratio = scrollView.contentOffset.x / scrollView.contentSize.width;
        CGPoint offset = CGPointMake(self.cycleScrollView.scrollView.contentSize.width * ratio, 0);
        [self.cycleScrollView.scrollView setContentOffset:offset animated:NO];
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (cycleScrollView == self.cycleScrollView) {
            self.isScrollCard = NO;
        }else if (cycleScrollView == self.iconScrollView) {
            self.isScrollIcon = NO;
        }
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView {
    if (cycleScrollView == self.cycleScrollView) {
        self.isScrollCard = NO;
    }else if (cycleScrollView == self.iconScrollView) {
        self.isScrollIcon = NO;
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

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = [UIImage imageNamed:@"bottom_arrow"];
    }
    return _arrowImgView;
}

@end
