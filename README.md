## GKCycleScrollView

[![Build Status](http://img.shields.io/travis/QuintGao/GKCycleScrollView/master.svg?style=flat)](https://travis-ci.org/QuintGao/GKCycleScrollView)
[![Pod Version](http://img.shields.io/cocoapods/v/GKCycleScrollView.svg?style=flat)](https://cocoapods.org/pods/GKCycleScrollView)
[![Pod Platform](http://img.shields.io/cocoapods/p/GKCycleScrollView.svg?style=flat)](https://cocoadocs.org/docsets/GKCycleScrollView/)
[![Pod License](http://img.shields.io/cocoapods/l/GKCycleScrollView.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![languages](https://img.shields.io/badge/language-objective--c-blue.svg)](#) 
[![support](https://img.shields.io/badge/support-ios%208%2B-orange.svg)](#) 

iOS轻量级图片、文字轮播器，支持自定义
===========
GKCycleScrollView是一款基于UIScrollView封装的轮播器，参考了[NewPagedFlowView](https://github.com/PageGuo/NewPagedFlowView)的实现方法，功能更加强大，使用更加便捷

## 主要功能
- 无第三方侵入，轻量级组件
- 支持自动轮播，无限轮播
- 支持cell缩放，设置上下左右间距
- 支持自定义当前cell的显示尺寸
- 支持自定义cell，自定义pageControl
- 支持cell透明度渐变
- 支持Masonry、SDAutolayout等第三方自动布局库

## 使用方法
### 1、创建GKCycleScrollView并设置数据源
```
GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, GK_STATUSBAR_NAVBAR_HEIGHT, kScreenW, 130)];
cycleScrollView1.dataSource = self;
[self.view addSubview:cycleScrollView1];
```
### 2、实现数据源方法
```
#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    return cell;
}
```
### 3、调用reloadData方法，刷新数据源
```
[self.cycleScrollView reloadData]
```

## 效果图

| 说明 | 效果图 |
|-------|-------|
| **横向轮播** | ![horizontal](https://github.com/QuintGao/GKCycleScrollView/blob/master/imgs/demo_horizontal.gif) |
| **纵向轮播** | ![vertical](https://github.com/QuintGao/GKCycleScrollView/blob/master/imgs/demo_vertical.gif) |
| **卡片效果** | ![card](https://github.com/QuintGao/GKCycleScrollView/blob/master/imgs/demo_card.gif) |
| **仿QQ聊天** | ![qqchat](https://github.com/QuintGao/GKCycleScrollView/blob/master/imgs/demo_qqchat.gif)|

## 说明
[GKCycleScrollView - 一个轻量级的自定义轮播图组件](https://www.jianshu.com/p/950ca713e6a9)

## 版本更新
2020.01.03  0.0.5 修复手动滑动不流畅问题，修复反向滑动停止后可能错乱问题
2019.11.22  0.0.4 修复自动轮播跳动问题及设置defaultSelectIndex后滚动错误问题
2019.10.11  添加自定义pageControl
