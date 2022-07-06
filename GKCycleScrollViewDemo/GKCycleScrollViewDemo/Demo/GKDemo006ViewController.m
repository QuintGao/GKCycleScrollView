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
    
    self.dataArr = @[
        @{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-594492e704dce1e8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-a1be3eff58b036cf.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-9d5fefd9e08c398b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-c57b15c77a047156.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-ab4bfe225b394c9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"}];
    
    self.cycleScrollView.dataSource = self;
    self.cycleScrollView.delegate = self;
//    self.cycleScrollView.topBottomMargin = 20;
    self.cycleScrollView.leftRightMargin = 20;
//    self.cycleScrollView.isChangeAlpha = NO;
//    self.cycleScrollView.leftRightMargin = 20;
    self.cycleScrollView.isAutoScroll = NO;
//    self.cycleScrollView.minimumCellAlpha = 1.0;
    self.cycleScrollView.scrollView.zoomScale = NO;
    self.cycleScrollView.scrollView.bounces = NO;
    self.cycleScrollView.scrollView.bouncesZoom = NO;
    
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
//    return CGSizeMake(kScreenW - 80, 160);
//    return CGSizeMake(cycleScrollView.frame.size.width - 100, cycleScrollView.frame.size.height);
    return CGSizeMake(kScreenW - 40, cycleScrollView.frame.size.height);
}

@end
