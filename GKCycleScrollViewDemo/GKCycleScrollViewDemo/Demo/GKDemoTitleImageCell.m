//
//  GKDemoTitleImageCell.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/22.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemoTitleImageCell.h"

@implementation GKDemoTitleImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.button];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.right.equalTo(self);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.width.height.mas_equalTo(100);
        }];
    }
    return self;
}

- (void)click {
    NSLog(@"subview click");
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        [_button setTitle:@"响应子视图" forState:UIControlStateNormal];
        [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _button.backgroundColor = UIColor.blackColor;
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
