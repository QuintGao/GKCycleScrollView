//
//  GKPageControl.h
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/21.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GKPageControlStyle) {
    GKPageControlStyleSystem,       // 系统，默认类型
    GKPageControlStyleCycle,        // 圆形
    GKPageControlStyleRectangle,    // 长方形
    GKPageControlStyleSquare,       // 正方形
    GKPageControlStyleSizeDot       // 大小点
};

@interface GKPageControl : UIPageControl

/// pageControl类型
@property (nonatomic, assign) GKPageControlStyle style;

/// 以下属性在style为GKPageControlStyleSizeDot时有效
/// 默认8 长方形默认16
@property (nonatomic, assign) CGFloat dotWidth;

/// 默认8 长方形默认2
@property (nonatomic, assign) CGFloat dotHeight;

/// 默认8
@property (nonatomic, assign) CGFloat dotMargin;

@end

NS_ASSUME_NONNULL_END
