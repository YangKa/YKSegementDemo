//
//  ViewController.m
//  YKSegementDemo
//
//  Created by qianzhan on 15/12/14.
//  Copyright © 2015年 qianzhan. All rights reserved.
//

#import "ViewController.h"
#import "YKLabel.h"

#define  RectWidth   self.view.frame.size.width
#define  RectGHeight self.view.frame.size.height
#define  labelWidth  self.view.frame.size.width/6
#define  labelHeight  40
@interface ViewController ()<UIScrollViewDelegate>{
    UIScrollView *_titleScrollView;
    
    UIView *_heightView;
    UIView *_heightViewLabel;
    
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSArray *titlesArr;

@property (nonatomic, strong) NSMutableArray *titleLabelArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _titlesArr = @[@"1111", @"2222", @"3333", @"4444", @"5555", @"6666", @"7777", @"8888", @"9999", @"0000"];
    _titleLabelArr = [NSMutableArray array];
    [self initTitleScrollView];
    [self initContentScrollView];
}


#pragma mark ----------------------init UI
- (void)initTitleScrollView{

    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150, RectWidth, labelHeight)];
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView.layer.cornerRadius = labelHeight/2;
    _titleScrollView.contentSize = CGSizeMake(labelWidth*_titlesArr.count, 0);
    [self.view addSubview:_titleScrollView];
    
    //title view
    for (int i = 0 ; i<_titlesArr.count; i++) {
        
        YKLabel *label = [[YKLabel alloc] initWithFrame:CGRectMake(i*labelWidth, 0, labelWidth, labelHeight)];
        label.tag = i;
        label.normalColor = [UIColor grayColor];
        label.text = _titlesArr[i];
        [_titleScrollView addSubview:label];
        
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLabel:)]];
        
        [_titleLabelArr addObject:label];
    }
    
    //height view
    _heightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    _heightView.backgroundColor = [UIColor clearColor];
    _heightView.backgroundColor = [UIColor redColor];
    _heightView.layer.cornerRadius = labelHeight/2;
    _heightView.clipsToBounds = YES;
    [_titleScrollView addSubview:_heightView];
    
    _heightViewLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelWidth*_titlesArr.count, labelHeight)];
    _heightViewLabel.backgroundColor = [UIColor clearColor];
    [_heightView addSubview:_heightViewLabel];
    
    for (int i = 0 ; i<_titlesArr.count; i++) {
        
        YKLabel *label = [[YKLabel alloc] initWithFrame:CGRectMake(i*labelWidth, 0, labelWidth, labelHeight)];
        label.tag = i;
        label.normalColor = [UIColor whiteColor];
        label.text = _titlesArr[i];
        [_heightViewLabel addSubview:label];
    }
    
}

- (void)initContentScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, RectWidth, 200)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (int i = 0 ; i<_titlesArr.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*RectWidth, 0, RectWidth, 200)];
        view.backgroundColor = [self returnRandomColor];
        [_scrollView addSubview:view];
    }
    
    _scrollView.contentSize = CGSizeMake(RectWidth*_titlesArr.count, 0);
}


#pragma mark ---------------------touch the label
- (void)touchLabel:(UITapGestureRecognizer*)gesture{
    NSInteger index = gesture.view.tag;
    [_scrollView setContentOffset:CGPointMake(RectWidth*index, 0) animated:YES];
}

#pragma mark ---------------------scale the label
- (void)scaleLabel{
    
    CGFloat x = ABS(_titleScrollView.contentOffset.x);
    
    NSInteger index = x/labelWidth;
    NSInteger leftIndex = index;
    NSInteger rightIndex = leftIndex+1;
    
    CGFloat rightScale = x/labelWidth - index;
    CGFloat leftScale  = 1-rightScale;
    
    YKLabel *leftLabel = _titleLabelArr[leftIndex];
    leftLabel.scale = leftScale;
    
    YKLabel *leftHeightLabel = _heightViewLabel.subviews[leftIndex];
    leftHeightLabel.scale = leftScale;
    
    if (rightIndex < _titlesArr.count) {
        
        YKLabel *rightLabel = _titleLabelArr[rightIndex];
        rightLabel.scale = rightScale;
        
        YKLabel *rightHeightLabel = _heightViewLabel.subviews[rightIndex];
        rightHeightLabel.scale = rightScale;
        
    }
}

#pragma mark ---------------------make the selected label centred
- (void)layoutTitleScrollView{
    
    CGFloat centerX = _heightView.center.x;
    CGPoint point = _titleScrollView.contentOffset;
    
    CGFloat moveDistance = centerX - point.x - RectWidth/2;
    if (_titleScrollView.contentSize.width - point.x - RectWidth >=moveDistance) {
        [_titleScrollView setContentOffset:CGPointMake(point.x+moveDistance, 0) animated:YES];
    }else{
        
    }
    
    if (centerX > _titleScrollView.contentSize.width/2) {//偏右
        CGFloat moveDistance = centerX - point.x - RectWidth/2;
        if (_titleScrollView.contentSize.width - point.x - RectWidth >=moveDistance) {
            [_titleScrollView setContentOffset:CGPointMake(point.x+moveDistance, 0) animated:YES];
        }else{
            [_titleScrollView setContentOffset:CGPointMake(_titleScrollView.contentSize.width-RectWidth, 0) animated:YES];
        }
    }else{//偏左
        CGFloat moveDistance = point.x + RectWidth/2 - centerX;
        if (_titleScrollView.contentOffset.x >= moveDistance) {
            [_titleScrollView setContentOffset:CGPointMake(point.x-moveDistance, 0) animated:YES];
        }else{
            [_titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark
#pragma mark -------------UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat value = ABS(scrollView.contentOffset.x/RectWidth);
    
    NSInteger leftIndex = (NSInteger)value;
    NSInteger rightIndex = leftIndex+1;
    
    CGFloat rightScale = value - leftIndex;
    CGFloat leftScale = 1-rightScale;
    
    YKLabel *leftLabel = _titleLabelArr[leftIndex];
    leftLabel.scale = leftScale;
    
    YKLabel *leftHeightLabel = _heightViewLabel.subviews[leftIndex];
    leftHeightLabel.scale = leftScale;
    
    if (rightIndex < _titlesArr.count) {
        
        YKLabel *rightLabel = _titleLabelArr[rightIndex];
        rightLabel.scale = rightScale;
        
        YKLabel *rightHeightLabel = _heightViewLabel.subviews[rightIndex];
        rightHeightLabel.scale = rightScale;
        
    }
    
    CGFloat x = (scrollView.contentOffset.x/RectWidth)*labelWidth;
    _heightView.frame = CGRectMake(x, 0, _heightView.frame.size.width, _heightView.frame.size.height);
    _heightViewLabel.frame = CGRectMake(-x, 0, _heightViewLabel.frame.size.width, _heightViewLabel.frame.size.height);
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self layoutTitleScrollView];
}

#pragma mark --------------random color
- (UIColor*)returnRandomColor{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}

#pragma mark --------------shake animation
- (void)shakeAnimationForView:(UIView*)view{
    CGPoint point = view.layer.position;
    CGPoint point1 = CGPointMake(point.x-1, point.y);
    CGPoint point2 = CGPointMake(point.x+1, point.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    animation.fromValue = [NSValue valueWithCGPoint:point1];
    animation.toValue = [NSValue valueWithCGPoint:point2];
    animation.autoreverses = YES;
    animation.duration = 0.2;
    [view.layer addAnimation:animation forKey:nil];
}
@end
