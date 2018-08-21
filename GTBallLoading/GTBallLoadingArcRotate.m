//
//  GTBallLoadingArcRotate.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/21.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "GTBallLoadingArcRotate.h"
#import "GTAnimDelegate.h"

static const CGFloat ballWidth = 13.f;
static const CGFloat ballScale = 1.5f;
static const NSTimeInterval animateDuration = 1.5f;

@interface GTBallLoadingArcRotate()<GTAnimDelegateDelegate>
// ball's container
@property (nonatomic, strong) UIVisualEffectView *ballContainer;
// first ball
@property (nonatomic, strong) UIView *ball1;
// second ball
@property (nonatomic, strong) UIView *ball2;
// third ball
@property (nonatomic, strong) UIView *ball3;
// whether should hide the balls
@property (nonatomic, assign, getter=isShouldDismiss) BOOL shouldDismiss;
@end

@implementation GTBallLoadingArcRotate

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.ballContainer];
        [self.ballContainer.contentView addSubview:self.ball1];
        [self.ballContainer.contentView addSubview:self.ball2];
        [self.ballContainer.contentView addSubview:self.ball3];
    }
    return self;
}

- (void)dealloc {
    [self dismiss];
}

#pragma mark - GTAnimDelegateDelegate

- (void)animationDidStart {
    CGFloat delay = .3f;
    CGFloat duration = animateDuration/2 - delay;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.ball1.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        self.ball2.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        self.ball3.transform = CGAffineTransformMakeScale(ballScale, ballScale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.ball1.transform = CGAffineTransformIdentity;
            self.ball2.transform = CGAffineTransformIdentity;
            self.ball3.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)animationDidStop {
    NSLog(@"-----------------animationDidStop-----------------");
    if (_shouldDismiss) { return; };
    [self startAnimation];
}

#pragma mark - Ball Path Animations

- (void)startAnimation {
    // 容器宽度
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
    [_ball1.layer addAnimation:animation1 forKey:nil];
    
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
    
    GTAnimDelegate *animDelegate = [[GTAnimDelegate alloc] init];
    animDelegate.delegate = self;
    animation3.delegate = animDelegate;
    
    [_ball3.layer addAnimation:animation3 forKey:@"animation"];
}

#pragma mark - 启动\停止 动画

- (void)start {
    _shouldDismiss = NO;
    [self startAnimation];
}

- (void)dismiss {
    _shouldDismiss = YES;
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
    GTBallLoadingArcRotate *loading = [[GTBallLoadingArcRotate alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    [loading start];
}

+ (void)hideInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[GTBallLoadingArcRotate class]]) {
            [(GTBallLoadingArcRotate *)subView dismiss];
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - Getters

-  (UIView *)ballContainer {
    if (!_ballContainer) {
        _ballContainer = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _ballContainer.frame = CGRectMake(0, 0, 100, 100);
        _ballContainer.center = self.center;
        _ballContainer.layer.cornerRadius = 10.f;
        _ballContainer.layer.masksToBounds = YES;
    }
    return _ballContainer;
}

- (UIView *)ball1 {
    if (!_ball1) {
        _ball1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball1.center = CGPointMake(ballWidth/2, _ballContainer.bounds.size.height/2);
        _ball1.layer.cornerRadius = ballWidth/2;
        _ball1.backgroundColor = [UIColor colorWithRed:102/255.0 green:201/255.0 blue:255/255.0 alpha:1];
    }
    return _ball1;
}

- (UIView *)ball2 {
    if (!_ball2) {
        _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2, _ballContainer.bounds.size.height/2);
        _ball2.layer.cornerRadius = ballWidth/2;
        _ball2.backgroundColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:74/255.0 alpha:1];
    }
    return _ball2;
}

- (UIView *)ball3 {
    if (!_ball3) {
        _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball3.center = CGPointMake(_ballContainer.bounds.size.width-ballWidth/2, _ballContainer.bounds.size.height/2);
        _ball3.layer.cornerRadius = ballWidth/2;
        _ball3.backgroundColor = [UIColor colorWithRed:254/255.0 green:212/255.0 blue:31/255.0 alpha:1];
    }
    return _ball3;
}

@end
