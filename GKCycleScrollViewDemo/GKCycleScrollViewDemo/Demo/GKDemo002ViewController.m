//
//  GKDemo002ViewController.m
//  GKCycleScrollViewDemo
//
//  Created by gaokun on 2019/9/18.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo002ViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import "PageControl/TAPageControl.h"
#import "GKDemoTitleImageCell.h"
#import "GKDemoTitleCell.h"

@interface GKDemo002ViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView1;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView3;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView4;
@property (nonatomic, strong) TAPageControl     *pageControl4;
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView5;

@end

@implementation GKDemo002ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@{@"title": @"GKCycleScrollView是一个轻量级可自定义轮播器", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640925739&di=cd001f10dfe79dffdc3ab56d70a8f2c9&imgtype=0&src=http%3A%2F%2Fp0.qhmsg.com%2Ft0133662f4be7939166.jpg"},
                     @{@"title": @"支持cell自定义，pageControl自定义", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924880&di=3723a43ebb2720c4800bdf57b744f5f5&imgtype=0&src=http%3A%2F%2Fimg.ewebweb.com%2Fuploads%2F20190403%2F15%2F1554275567-BAZdrhRItG.jpg"},
                     @{@"title": @"支持设置左右间距，上下间距（缩放）", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924879&di=94c758997427348f0c7e92c1a6039641&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F0a687d5c3d5b579293ff1a9051d357856b0ff67c10199-uPCIQB_fw658"},
                     @{@"title": @"支持自动轮播，无限轮播", @"img_url": @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604640924879&di=5ef347a866fe08ea5dd7582a7f3f2f0c&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-12%2F5a2f7774d280e.jpg"},
                     @{@"title": @"支持cell之间透明度渐变", @"img_url": @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1443270937,1017525655&fm=26&gp=0.jpg"}];
    
    // ---------------------------轮播图demo1--------------------------
    // 默认样式：无缩放，自动轮播，无限轮播
    GKCycleScrollView *cycleScrollView1 = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, GK_STATUSBAR_NAVBAR_HEIGHT, kScreenW, 130)];
    cycleScrollView1.direction = GKCycleScrollViewScrollDirectionVertical;
    cycleScrollView1.dataSource = self;
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
    cycleScrollView2.direction = GKCycleScrollViewScrollDirectionVertical;
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
    cycleScrollView3.direction = GKCycleScrollViewScrollDirectionVertical;
    cycleScrollView3.dataSource = self;
    cycleScrollView3.delegate = self;
    cycleScrollView3.minimumCellAlpha = 0.5;
    cycleScrollView3.leftRightMargin = 20.0f;
    cycleScrollView3.topBottomMargin = 20.0f;
    //    cycleScrollView3.isAutoScroll = NO;
    [self.view addSubview:cycleScrollView3];
    self.cycleScrollView3 = cycleScrollView3;
    
    GKPageControl *pageControl3 = [[GKPageControl alloc] init];
    pageControl3.style = GKPageControlStyleSizeDot;
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
    cycleScrollView4.direction = GKCycleScrollViewScrollDirectionVertical;
    cycleScrollView4.dataSource = self;
    cycleScrollView4.delegate = self;
    cycleScrollView4.isChangeAlpha = NO;
    //    cycleScrollView4.isAutoScroll = NO;
    cycleScrollView4.isInfiniteLoop = NO;
    cycleScrollView4.leftRightMargin = 20.0f;
    cycleScrollView4.topBottomMargin = 20.0f;
    [self.view addSubview:cycleScrollView4];
    self.cycleScrollView4 = cycleScrollView4;
    
    TAPageControl *pageControl4 = [[TAPageControl alloc] init];
    pageControl4.numberOfPages = self.dataArr.count;
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
    cycleScrollView5.direction = GKCycleScrollViewScrollDirectionVertical;
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
    if (cycleScrollView == self.cycleScrollView5) return CGSizeMake(kScreenW, 40);
    return CGSizeMake(kScreenW - 100, 130);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    if (cycleScrollView == self.cycleScrollView4) {
        self.pageControl4.currentPage = index;
    }
}

@end
