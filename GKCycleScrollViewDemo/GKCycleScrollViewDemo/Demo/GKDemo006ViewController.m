//
//  GKDemo006ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2021/2/9.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import "GKDemo006ViewController.h"
#import "GKCycleScrollView.h"
#import <SDWebImage/SDWebImage.h>

@interface GKDemo006ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet GKCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation GKDemo006ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640925739&di=cd001f10dfe79dffdc3ab56d70a8f2c9&imgtype=0&src=http%3A%2F%2Fp0.qhmsg.com%2Ft0133662f4be7939166.jpg"},
                     @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924880&di=3723a43ebb2720c4800bdf57b744f5f5&imgtype=0&src=http%3A%2F%2Fimg.ewebweb.com%2Fuploads%2F20190403%2F15%2F1554275567-BAZdrhRItG.jpg"},
                     @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3549859657,668339084&fm=26&gp=0.jpg"},
                     @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924879&di=5ef347a866fe08ea5dd7582a7f3f2f0c&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-12%2F5a2f7774d280e.jpg"},
                     @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1443270937,1017525655&fm=26&gp=0.jpg"}];
    
    self.cycleScrollView.dataSource = self;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.topBottomMargin = 20;
    self.cycleScrollView.leftRightMargin = 20;
    self.cycleScrollView.isChangeAlpha = NO;
    
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
    }
    // 设置数据
    NSDictionary *dict = self.dataArr[index];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    cell.layer.cornerRadius = 10;
    return cell;
}

- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(kScreenW - 80, 160);
}

@end
