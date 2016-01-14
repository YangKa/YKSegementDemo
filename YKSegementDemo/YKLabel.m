//
//  YKLabel.m
//  YKSegementDemo
//
//  Created by qianzhan on 15/12/14.
//  Copyright © 2015年 qianzhan. All rights reserved.
//

#import "YKLabel.h"

@implementation YKLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:17];
        self.scale = 0.0;
        self.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    
   // self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1.0];
    
    CGFloat transferScale = 0.7+0.3*scale;
    self.transform = CGAffineTransformMakeScale(transferScale, transferScale);
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    self.textColor = _normalColor;
}

@end
