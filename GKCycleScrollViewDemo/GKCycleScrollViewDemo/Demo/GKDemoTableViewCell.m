//
//  GKDemoTableViewCell.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2021/1/14.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import "GKDemoTableViewCell.h"
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import <SDWebImage/SDWebImage.h>

@interface GKDemoTableViewCell()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;

@end

@implementation GKDemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dataArr = @[
            @{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-594492e704dce1e8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
            @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-a1be3eff58b036cf.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
            @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-9d5fefd9e08c398b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
            @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-c57b15c77a047156.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
            @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-ab4bfe225b394c9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"}];
        
        // ---------------------------轮播图demo1--------------------------
        // 默认样式：无缩放，自动轮播，无限轮播
        GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
        cycleScrollView.dataSource = self;
        cycleScrollView.delegate = self;
        cycleScrollView.isChangeAlpha = NO;
        cycleScrollView.isAutoScroll = NO;
        cycleScrollView.isInfiniteLoop = NO;
        cycleScrollView.leftRightMargin = -kAdapter(20.0f);
        cycleScrollView.topBottomMargin = kAdapter(30.0f);
    //    cycleScrollView.leftRightMargin = 20.0f;
        [self.contentView addSubview:cycleScrollView];
        self.cycleScrollView = cycleScrollView;
        cycleScrollView.backgroundColor = UIColor.redColor;
        cycleScrollView.scrollView.backgroundColor = UIColor.blueColor;
        cycleScrollView.defaultSelectIndex = 2;
        
    //    GKPageControl *pageControl = [[GKPageControl alloc] initWithFrame:CGRectMake(0, cycleScrollView.frame.size.height - 15, 160, 15)];
    //    pageControl.style = GKPageControlStyleCycle;
    //    cycleScrollView.pageControl = pageControl;
    //    [cycleScrollView addSubview:pageControl];
        [cycleScrollView reloadData];
    }
    return self;
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
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(300, 200.0f);
}

@end
