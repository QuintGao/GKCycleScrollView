//
//  GKCycleScrollViewCell.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKCycleScrollViewCell.h"

@implementation GKCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.coverView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    !self.didCellClick ? : self.didCellClick(self.tag);
}

- (void)setupCellFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.imageView.frame, frame)) return;
    
    self.imageView.frame = frame;
    self.coverView.frame = frame;
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

@end
