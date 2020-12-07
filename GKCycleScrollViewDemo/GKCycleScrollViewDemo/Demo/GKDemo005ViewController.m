//
//  GKDemo005ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/11/22.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo005ViewController.h"
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import <SDWebImage/SDWebImage.h>

@interface GKDemo005ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;

@end

@implementation GKDemo005ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640925739&di=cd001f10dfe79dffdc3ab56d70a8f2c9&imgtype=0&src=http%3A%2F%2Fp0.qhmsg.com%2Ft0133662f4be7939166.jpg"},
                     @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924880&di=3723a43ebb2720c4800bdf57b744f5f5&imgtype=0&src=http%3A%2F%2Fimg.ewebweb.com%2Fuploads%2F20190403%2F15%2F1554275567-BAZdrhRItG.jpg"},
                     @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3549859657,668339084&fm=26&gp=0.jpg"},
                     @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924879&di=5ef347a866fe08ea5dd7582a7f3f2f0c&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-12%2F5a2f7774d280e.jpg"},
                     @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1443270937,1017525655&fm=26&gp=0.jpg"}];
    
    // ---------------------------轮播图demo1--------------------------
    // 默认样式：无缩放，自动轮播，无限轮播
    GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, GK_STATUSBAR_NAVBAR_HEIGHT + 100, kScreenW, 300)];
    cycleScrollView.dataSource = self;
    cycleScrollView.delegate = self;
    cycleScrollView.isChangeAlpha = NO;
    cycleScrollView.isAutoScroll = NO;
    cycleScrollView.leftRightMargin = -kAdapter(10.0f);
    cycleScrollView.topBottomMargin = kAdapter(30.0f);
//    cycleScrollView.leftRightMargin = 20.0f;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
//    GKPageControl *pageControl = [[GKPageControl alloc] initWithFrame:CGRectMake(0, cycleScrollView.frame.size.height - 15, 160, 15)];
//    pageControl.style = GKPageControlStyleCycle;
//    cycleScrollView.pageControl = pageControl;
//    [cycleScrollView addSubview:pageControl];
    [cycleScrollView reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.imageView.layer.cornerRadius = 10;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    // 设置数据
    NSDictionary *dict = self.dataArr[index];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(200, 200.0f);
}

@end
