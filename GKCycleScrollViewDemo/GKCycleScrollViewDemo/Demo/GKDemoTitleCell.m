//
//  GKDemoTitleCell.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/22.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemoTitleCell.h"

@implementation GKDemoTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.right.equalTo(self);
        }];
        
        [self.imageView removeFromSuperview];
        [self.coverView removeFromSuperview];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
