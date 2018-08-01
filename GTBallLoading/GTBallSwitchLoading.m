//
//  GTBallSwitchLoading.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/1.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "GTBallSwitchLoading.h"

static CGFloat ballWidth = 13.f;
static CGFloat animateDelay = .1f;
static CGFloat animateDuration = 4.f;

@interface GTBallSwitchLoading ()<CAAnimationDelegate>
{
    UIVisualEffectView *_ballContainer;
    UIView *_ball1;
    UIView *_ball2;
    UIView *_ball3;
    
    BOOL _hideLoading;
}
@end

@implementation GTBallSwitchLoading

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _ballContainer = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _ballContainer.frame = CGRectMake(0, 0, 80, 80);
    _ballContainer.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _ballContainer.layer.cornerRadius = 10.f;
    _ballContainer.layer.masksToBounds = YES;
    [self addSubview:_ballContainer];
    
    _ball1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball1.center = CGPointMake(ballWidth/2, _ballContainer.bounds.size.height/2);
    _ball1.layer.cornerRadius = ballWidth/2;
    _ball1.backgroundColor = [UIColor colorWithRed:102/255.0 green:201/255.0 blue:255/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball1];
    
    _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2, _ballContainer.bounds.size.height/2);
    _ball2.layer.cornerRadius = ballWidth/2;
    _ball2.backgroundColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:74/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball2];
    
    _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball3.center = CGPointMake(_ballContainer.bounds.size.width-ballWidth/2, _ballContainer.bounds.size.height/2);
    _ball3.layer.cornerRadius = ballWidth/2;
    _ball3.backgroundColor = [UIColor colorWithRed:254/255.0 green:212/255.0 blue:31/255.0 alpha:1];
    [_ballContainer.contentView addSubview:_ball3];
}

/**
 * 开启动画
 */
- (void)startBallPathAnimation {
    // 容器宽度
    CGFloat width = _ballContainer.bounds.size.width;
    // 动画半径
    CGFloat r = (width - ballWidth)/4;
    // 左边圆心
    CGPoint leftCenter = CGPointMake(ballWidth/2 + r, width/2);
    // 右边圆心
    CGPoint rightCenter = CGPointMake(width/2 + r, width/2);
    // 每次动画执行时间
    CGFloat perDuration = (animateDuration - 7*animateDelay)/6;
    // 每次动画开始时间 (一共6次动画)
    CGFloat beginTime1 = animateDelay;
    CGFloat beginTime2 = beginTime1 + perDuration + animateDelay;
    CGFloat beginTime3 = beginTime2 + perDuration + animateDelay;
    CGFloat beginTime4 = beginTime3 + perDuration + animateDelay;
    CGFloat beginTime5 = beginTime4 + perDuration + animateDelay;
    CGFloat beginTime6 = beginTime5 + perDuration + animateDelay;

    //--------------------------第1个球--------------------------//
    
    CAKeyframeAnimation *animation1_1 = [self createAnimationWithBeginPoint:_ball1.center arcCenter:leftCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime1 duration:perDuration];
    
    CAKeyframeAnimation *animation1_2 = [self createAnimationWithBeginPoint:_ball1.center arcCenter:rightCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime2 duration:perDuration];
    
    CAKeyframeAnimation *animation1_3 = [self createAnimationWithBeginPoint:_ball1.center arcCenter:rightCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime4 duration:perDuration];
    
    CAKeyframeAnimation *animation1_4 = [self createAnimationWithBeginPoint:_ball1.center arcCenter:leftCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime5 duration:perDuration];

    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.animations = @[animation1_1, animation1_2, animation1_3, animation1_4];
    group1.duration = animateDuration;
    [_ball1.layer addAnimation:group1 forKey:@"group1"];
    
    
    //--------------------------第2个球--------------------------//
    
    CAKeyframeAnimation *animation2_1 = [self createAnimationWithBeginPoint:_ball2.center arcCenter:leftCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime1 duration:perDuration];
    
    CAKeyframeAnimation *animation2_2 = [self createAnimationWithBeginPoint:_ball2.center arcCenter:leftCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime3 duration:perDuration];
    
    CAKeyframeAnimation *animation2_3 = [self createAnimationWithBeginPoint:_ball2.center arcCenter:rightCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime4 duration:perDuration];
    
    CAKeyframeAnimation *animation2_4 = [self createAnimationWithBeginPoint:_ball2.center arcCenter:rightCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime6 duration:perDuration];
    
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.animations = @[animation2_1, animation2_2, animation2_3, animation2_4];
    group2.duration = animateDuration;
    [_ball2.layer addAnimation:group2 forKey:@"group2"];
    
    
    //--------------------------第3个球--------------------------//
    
    CAKeyframeAnimation *animation3_1 = [self createAnimationWithBeginPoint:_ball3.center arcCenter:rightCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime2 duration:perDuration];
    
    CAKeyframeAnimation *animation3_2 = [self createAnimationWithBeginPoint:_ball3.center arcCenter:leftCenter radius:r startAngle:0 endAngle:M_PI beginTime:beginTime3 duration:perDuration];
    
    CAKeyframeAnimation *animation3_3 = [self createAnimationWithBeginPoint:_ball3.center arcCenter:leftCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime5 duration:perDuration];
    
    CAKeyframeAnimation *animation3_4 = [self createAnimationWithBeginPoint:_ball3.center arcCenter:rightCenter radius:r startAngle:M_PI endAngle:0 beginTime:beginTime6 duration:perDuration];
    
    CAAnimationGroup *group3 = [CAAnimationGroup animation];
    group3.animations = @[animation3_1, animation3_2, animation3_3, animation3_4];
    group3.duration = animateDuration;
    group3.delegate = self;
    [_ball3.layer addAnimation:group3 forKey:@"group3"];
}

/**
 * 创建一个动画
 */
- (CAKeyframeAnimation *)createAnimationWithBeginPoint:(CGPoint)beginPoint
                                             arcCenter:(CGPoint)arcCenter
                                                radius:(CGFloat)radius
                                            startAngle:(CGFloat)startAngle
                                              endAngle:(CGFloat)endAngle
                                             beginTime:(CGFloat)beginTime
                                              duration:(CGFloat)duration {
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = duration;
    animation.beginTime = beginTime;
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_hideLoading) {return;}
    [self startBallPathAnimation];
}


#pragma mark - 启动\停止 动画

- (void)start {
    _hideLoading = NO;
    [self startBallPathAnimation];
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
    GTBallSwitchLoading *loading = [[GTBallSwitchLoading alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    [loading start];
}

+ (void)hideInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[GTBallSwitchLoading class]]) {
            [(GTBallSwitchLoading *)subView stop];
            [subView removeFromSuperview];
        }
    }
}

@end
