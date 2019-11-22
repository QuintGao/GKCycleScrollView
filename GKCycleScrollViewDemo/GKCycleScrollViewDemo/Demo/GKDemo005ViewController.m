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
    
    self.dataArr = @[@{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"http://img5.imgtn.bdimg.com/it/u=2018579695,196237912&fm=26&gp=0.jpg"},
                     @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"http://img3.imgtn.bdimg.com/it/u=1809899943,4092597772&fm=15&gp=0.jpg"},
                     @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"http://img0.imgtn.bdimg.com/it/u=240303812,1014789226&fm=26&gp=0.jpg"},
                     @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"http://img1.imgtn.bdimg.com/it/u=2078392142,3408530103&fm=15&gp=0.jpg"},
                     @{@"title": @"支持cell之间透明度渐变", @"img_url": @"http://img2.imgtn.bdimg.com/it/u=1442201060,4140956584&fm=26&gp=0.jpg"}];
    
    // ---------------------------轮播图demo1--------------------------
    // 默认样式：无缩放，自动轮播，无限轮播
    GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, GK_STATUSBAR_NAVBAR_HEIGHT, kScreenW, 130)];
    cycleScrollView.dataSource = self;
    cycleScrollView.leftRightMargin = 20.0f;
    cycleScrollView.defaultSelectIndex = 3;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    GKPageControl *pageControl = [[GKPageControl alloc] initWithFrame:CGRectMake(0, cycleScrollView.frame.size.height - 15, 160, 15)];
    pageControl.style = GKPageControlStyleCycle;
    cycleScrollView.pageControl = pageControl;
    [cycleScrollView addSubview:pageControl];
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
    }
    
    // 设置数据
    NSDictionary *dict = self.dataArr[index];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
//- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
//    return CGSizeMake(kScreenW - 100.0f, 130.0f);
//}

@end
