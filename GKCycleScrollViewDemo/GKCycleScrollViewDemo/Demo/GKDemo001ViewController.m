//
//  GKDemo001ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/18.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo001ViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import "PageControl/TAPageControl.h"
#import "GKDemoTitleImageCell.h"
#import "GKDemoTitleCell.h"

@interface GKDemo001ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView1;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView3;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView4;
@property (nonatomic, strong) TAPageControl     *pageControl4;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView5;

@end

@implementation GKDemo001ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
        @{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-594492e704dce1e8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-a1be3eff58b036cf.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-9d5fefd9e08c398b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-c57b15c77a047156.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"},
        @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://upload-images.jianshu.io/upload_images/1598505-ab4bfe225b394c9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"}];
    
    // ---------------------------轮播图demo1--------------------------
    // 默认样式：无缩放，自动轮播，无限轮播
    GKCycleScrollView *cycleScrollView1 = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, GK_STATUSBAR_NAVBAR_HEIGHT, kScreenW, 130)];
    cycleScrollView1.dataSource = self;
    cycleScrollView1.delegate = self;
    [self.view addSubview:cycleScrollView1];
    self.cycleScrollView1 = cycleScrollView1;
    
    GKPageControl *pageControl1 = [[GKPageControl alloc] initWithFrame:CGRectMake(0, cycleScrollView1.frame.size.height - 15, 160, 15)];
    pageControl1.style = GKPageControlStyleRectangle;
    cycleScrollView1.pageControl = pageControl1;
    [cycleScrollView1 addSubview:pageControl1];
    [cycleScrollView1 reloadData];
    
    // ---------------------------轮播图demo2--------------------------
    // 左右间距：无缩放，自动轮播，不无限轮播
    GKCycleScrollView *cycleScrollView2 = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView1.frame) + 20, kScreenW, 130)];
    cycleScrollView2.dataSource = self;
    cycleScrollView2.minimumCellAlpha = 0.5;
    cycleScrollView2.leftRightMargin = 20.0f;
    cycleScrollView2.isInfiniteLoop = NO;
    [self.view addSubview:cycleScrollView2];
    self.cycleScrollView2 = cycleScrollView2;
    
    GKPageControl *pageControl2 = [[GKPageControl alloc] initWithFrame:CGRectMake(0, cycleScrollView2.frame.size.height - 15, kScreenW, 15)];
    pageControl2.style = GKPageControlStyleCycle;
    cycleScrollView2.pageControl = pageControl2;
    [cycleScrollView2 addSubview:pageControl2];
    [cycleScrollView2 reloadData];
    
    // ---------------------------轮播图demo3--------------------------
    // 缩放样式：Masonry布局，自定义尺寸，无限轮播
    GKCycleScrollView *cycleScrollView3 = [[GKCycleScrollView alloc] init];
    cycleScrollView3.dataSource = self;
    cycleScrollView3.delegate = self;
    cycleScrollView3.minimumCellAlpha = 0.0;
    cycleScrollView3.leftRightMargin = 20.0f;
    cycleScrollView3.topBottomMargin = 20.0f;
//    cycleScrollView3.isAutoScroll = NO;
    [self.view addSubview:cycleScrollView3];
    self.cycleScrollView3 = cycleScrollView3;
    
    GKPageControl *pageControl3 = [[GKPageControl alloc] init];
    pageControl3.style = GKPageControlStyleSizeDot;
    pageControl3.pageIndicatorTintColor = UIColor.redColor;
    pageControl3.currentPageIndicatorTintColor = UIColor.blueColor;
    cycleScrollView3.pageControl = pageControl3;
    [cycleScrollView3 addSubview:pageControl3];
    [cycleScrollView3 reloadData];
    
    [cycleScrollView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(cycleScrollView2.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(130.0f);
    }];
    
    [pageControl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView3);
        make.bottom.equalTo(cycleScrollView3);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    // ---------------------------轮播图demo4--------------------------
    // 缩放样式：SDAutolayout布局，自定义尺寸，自定义cell
    GKCycleScrollView *cycleScrollView4 = [[GKCycleScrollView alloc] init];
    cycleScrollView4.dataSource = self;
    cycleScrollView4.delegate = self;
    cycleScrollView4.isChangeAlpha = NO;
//    cycleScrollView4.isAutoScroll = NO;
//    cycleScrollView4.isInfiniteLoop = NO;
    cycleScrollView4.leftRightMargin = 20.0f;
    cycleScrollView4.topBottomMargin = 20.0f;
    [self.view addSubview:cycleScrollView4];
    self.cycleScrollView4 = cycleScrollView4;
    
    TAPageControl *pageControl4 = [[TAPageControl alloc] init];
    pageControl4.numberOfPages = self.dataArr.count;
    pageControl4.dotColor = UIColor.redColor;
    [cycleScrollView4 addSubview:pageControl4];
    self.pageControl4 = pageControl4;
    [cycleScrollView4 reloadData];
    
    cycleScrollView4.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(cycleScrollView3, 20.0f)
    .heightIs(130.0f);
    
    pageControl4.frame = CGRectMake(0, 130-15, kScreenW, 15);
    [pageControl4 sizeToFit];
    
    // ---------------------------轮播图demo5--------------------------
    // 文字样式：Masonry布局，自定义尺寸，自定义cell
    GKCycleScrollView *cycleScrollView5 = [[GKCycleScrollView alloc] init];
    cycleScrollView5.dataSource = self;
    cycleScrollView5.delegate = self;
    cycleScrollView5.isChangeAlpha = NO;
    [self.view addSubview:cycleScrollView5];
    self.cycleScrollView5 = cycleScrollView5;
    
    [cycleScrollView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(cycleScrollView4.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [cycleScrollView5 reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        if (cycleScrollView == self.cycleScrollView3) {
            cell.layer.cornerRadius = 5.0f;
            cell.layer.masksToBounds = YES;
        }else if (cycleScrollView == self.cycleScrollView4) {
            cell = [GKDemoTitleImageCell new];
        }else if (cycleScrollView == self.cycleScrollView5) {
            cell = [GKDemoTitleCell new];
        }
    }
    
    // 设置数据
    NSDictionary *dict = self.dataArr[index];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([cell isKindOfClass:[GKDemoTitleImageCell class]]) {
        GKDemoTitleImageCell *titleImageCell = (GKDemoTitleImageCell *)cell;
        titleImageCell.titleLabel.text = dict[@"title"];
    }
    
    if ([cell isKindOfClass:[GKDemoTitleCell class]]) {
        GKDemoTitleCell *titleCell = (GKDemoTitleCell *)cell;
        titleCell.titleLabel.text = dict[@"title"];
    }
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    if (cycleScrollView == self.cycleScrollView1) return CGSizeMake(kScreenW, 130);
    if (cycleScrollView == self.cycleScrollView5) return CGSizeMake(kScreenW, 40);
    return CGSizeMake(kScreenW - 100, 130);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    if (cycleScrollView == self.cycleScrollView4) {
        self.pageControl4.currentPage = index;
        
        GKDemoTitleImageCell *cell = (GKDemoTitleImageCell *)cycleScrollView.currentCell;
        NSLog(@"%@", cell.titleLabel.text);
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    NSLog(@"cell点击，index=%zd", index);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView scrollingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex ratio:(CGFloat)ratio {
    if (cycleScrollView != self.cycleScrollView1) return;
    
    NSLog(@"fromIndex:%zd,toIndex:%zd,ratio:%f", fromIndex, toIndex, ratio);
}

@end
