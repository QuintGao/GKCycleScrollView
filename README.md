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


