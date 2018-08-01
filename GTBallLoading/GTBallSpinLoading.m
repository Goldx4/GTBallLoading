//
//  GTBallSpinLoading.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/1.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "GTBallSpinLoading.h"

static CGFloat ballWidth = 13.f;
static CGFloat margin = 3.f;
static CGFloat ballScale = 1.5f;
static CGFloat animateDuration = 1.5f;

@interface GTBallSpinLoading ()<CAAnimationDelegate>
{
    UIVisualEffectView *_ballContainer;
    UIView *_ball1;
    UIView *_ball2;
    UIView *_ball3;
    
    BOOL _hideLoading;
}
@end

@implementation GTBallSpinLoading

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _ballContainer = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _ballContainer.frame = CGRectMake(0, 0, 100, 100);
    _ballContainer.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _ballContainer.layer.cornerRadius = 10.f;
    _ballContainer.layer.masksToBounds = YES;
    [self addSubview:_ballContainer];
    
    _ball1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball1.center = CGPointMake(ballWidth/2 + margin, _ballContainer.bounds.size.height/2);
    _ball1.layer.cornerRadius = ballWidth/2;
    _ball1.backgroundColor = [UIColor colorWithRed:54/255.0 green:136/255.0 blue:250/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball1];
    
    _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2, _ballContainer.bounds.size.height/2);
    _ball2.layer.cornerRadius = ballWidth/2;
    _ball2.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball2];
    
    _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball3.center = CGPointMake(_ballContainer.bounds.size.width-ballWidth/2-margin, _ballContainer.bounds.size.height/2);
    _ball3.layer.cornerRadius = ballWidth/2;
    _ball3.backgroundColor = [UIColor colorWithRed:234/255.0 green:67/255.0 blue:69/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball3];
}

- (void)startPathAnimation {
    
    CGFloat width = _ballContainer.bounds.size.width;
    // 小圆半径
    CGFloat r = (ballWidth)*ballScale/2;
    // 大圆半径
    CGFloat R = (width/2 + r)/2;
    
    //--------------------------第1个球--------------------------//
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:_ball1.center];
    // 1.大圆路径
    [path1 addArcWithCenter:CGPointMake(R + r, width/2) radius:R startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    // 2.小圆路径
    UIBezierPath *path1_1 = [UIBezierPath bezierPath];
    [path1_1 addArcWithCenter:_ball2.center radius:r*2 startAngle:M_PI*2 endAngle:M_PI clockwise:NO];
    [path1 appendPath:path1_1];
    // 3.回到原处
    [path1 addLineToPoint:_ball1.center];
    // 创建动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.path = path1.CGPath;
    animation1.removedOnCompletion = YES;
    animation1.duration = animateDuration;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_ball1.layer addAnimation:animation1 forKey:@"animation1"];
    
    //--------------------------第3个球--------------------------//
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:_ball3.center];
    // 1.大圆路径
    [path3 addArcWithCenter:CGPointMake(width - R - r, width/2) radius:R startAngle:0 endAngle:M_PI clockwise:NO];
    // 2.小圆路径
    UIBezierPath *path3_3 = [UIBezierPath bezierPath];
    [path3_3 addArcWithCenter:_ball2.center radius:r*2 startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [path3 appendPath:path3_3];
    // 3.回到原处
    [path3 addLineToPoint:_ball3.center];
    // 创建动画
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.path = path3.CGPath;
    animation3.removedOnCompletion = YES;
    animation3.duration = animateDuration;
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation3.delegate = self;
    [_ball3.layer addAnimation:animation3 forKey:@"animation3"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    CGFloat delay = .3f;
    CGFloat duration = animateDuration/2 - delay;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        _ball1.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        _ball2.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        _ball3.transform = CGAffineTransformMakeScale(ballScale, ballScale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _ball1.transform = CGAffineTransformIdentity;
            _ball2.transform = CGAffineTransformIdentity;
            _ball3.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_hideLoading) {return;}
    [self startPathAnimation];
}

#pragma mark - 启动\停止 动画

- (void)start {
    _hideLoading = NO;
    [self startPathAnimation];
}

- (void)stop {
    _hideLoading = YES;
    [_ball1.layer removeAllAnimations];
    [_ball1 removeFromSuperview];
    [_ball2.layer removeAllAnimations];
    [_ball2 removeFromSuperview];
    [_ball3.layer removeAllAnimations];
    [_ball3 removeFromSuperview];
}

#pragma mark - 显示\隐藏

+ (void)showInView:(UIView *)view {
    [self hideInView:view];
    GTBallSpinLoading *loading = [[GTBallSpinLoading alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    [loading start];
}

+ (void)hideInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[GTBallSpinLoading class]]) {
            [(GTBallSpinLoading *)subView stop];
            [subView removeFromSuperview];
        }
    }
}

@end
