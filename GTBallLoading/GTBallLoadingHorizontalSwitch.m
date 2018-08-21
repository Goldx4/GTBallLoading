//
//  GTBallLoadingHorizontalSwitch.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/21.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "GTBallLoadingHorizontalSwitch.h"
#import "GTAnimDelegate.h"

static const CGFloat ballWidth = 17.f;

@interface GTBallLoadingHorizontalSwitch()<GTAnimDelegateDelegate>
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

@implementation GTBallLoadingHorizontalSwitch

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

- (void)animationDidStop {
    if (_shouldDismiss) {
        return;
    };
    [self startAnimation];
    NSLog(@"-----------------animationDidStop-----------------");
}

#pragma mark - Ball Path Animations

- (void)startAnimation {
    // 容器宽度
    CGFloat width = _ballContainer.bounds.size.width;
    // 小圆半径
    CGFloat r = ballWidth/2;
    // 每次动画间隔时间
    NSTimeInterval perAnimationDelay = .1f;
    // 每次动画时间
    NSTimeInterval perAnimationDuration = 1.f;
    // 动画总时间
    NSTimeInterval totalDuration = (perAnimationDuration + perAnimationDelay)*3;
    
    NSTimeInterval beginTime1_1 = perAnimationDelay;
    NSTimeInterval beginTime1_2 = perAnimationDelay + beginTime1_1 + perAnimationDuration;
    NSTimeInterval beginTime1_3 = perAnimationDelay + beginTime1_2 + perAnimationDuration + perAnimationDuration/2;
    
    NSTimeInterval beginTime2_1 = perAnimationDelay + perAnimationDuration/2;
    NSTimeInterval beginTime2_2 = perAnimationDelay + beginTime2_1 + perAnimationDuration/2;
    NSTimeInterval beginTime2_3 = perAnimationDelay + beginTime2_2 + perAnimationDuration;
    
    NSTimeInterval beginTime3_1 = perAnimationDelay;
    NSTimeInterval beginTime3_2 = perAnimationDelay + beginTime3_1 + perAnimationDuration + perAnimationDuration/2;
    NSTimeInterval beginTime3_3 = perAnimationDelay + beginTime3_2 + perAnimationDuration/2;
    
    // 共三次变换
    // 初始状态 1(灰) 2(红) 3(蓝)
    // 变动状态 2(红) 3(蓝) 1(灰)
    // 变动状态 3(蓝) 1(灰) 2(红)
    // 恢复状态 1(灰) 2(红) 3(蓝)
    
    // 第1次变换
    // 1->右
    CABasicAnimation *animation1_1 = [self createAnimationWithBeginTime:beginTime1_1 duration:perAnimationDuration toValue:@(width-r)];
    // 2->左
    CABasicAnimation *animation2_1 = [self createAnimationWithBeginTime:beginTime2_1 duration:perAnimationDuration/2 toValue:@(r)];
    // 3->中
    CABasicAnimation *animation3_1 = [self createAnimationWithBeginTime:beginTime3_1 duration:perAnimationDuration/2 toValue:@(width/2)];
    
    // 第2次变换
    // 1->中
    CABasicAnimation *animation1_2 = [self createAnimationWithBeginTime:beginTime1_2 duration:perAnimationDuration/2 toValue:@(width/2)];
    // 2->右
    CABasicAnimation *animation2_2 = [self createAnimationWithBeginTime:beginTime2_2 duration:perAnimationDuration toValue:@(width-r)];
    // 3->左
    CABasicAnimation *animation3_2 = [self createAnimationWithBeginTime:beginTime3_2 duration:perAnimationDuration/2 toValue:@(r)];
    
    // 恢复原始状态
    // 1->左
    CABasicAnimation *animation1_3 = [self createAnimationWithBeginTime:beginTime1_3 duration:perAnimationDuration/2 toValue:@(r)];
    // 2->中
    CABasicAnimation *animation2_3 = [self createAnimationWithBeginTime:beginTime2_3 duration:perAnimationDuration/2 toValue:@(width/2)];
    // 3->右
    CABasicAnimation *animation3_3 = [self createAnimationWithBeginTime:beginTime3_3 duration:perAnimationDuration toValue:@(width-r)];
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.animations = @[animation1_1, animation1_2, animation1_3];
    group1.duration = totalDuration;
    
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.animations = @[animation2_1, animation2_2, animation2_3];
    group2.duration = totalDuration;

    CAAnimationGroup *group3 = [CAAnimationGroup animation];
    group3.animations = @[animation3_1, animation3_2, animation3_3];
    group3.duration = totalDuration;
    
    GTAnimDelegate *animDelegate = [[GTAnimDelegate alloc] init];
    animDelegate.delegate = self;
    group3.delegate = animDelegate;
    
    [self.ball1.layer addAnimation:group1 forKey:@"group1"];
    [self.ball2.layer addAnimation:group2 forKey:@"group2"];
    [self.ball3.layer addAnimation:group3 forKey:@"group3"];
}

- (CABasicAnimation *)createAnimationWithBeginTime:(NSTimeInterval)beginTime
                                          duration:(NSTimeInterval)duration
                                           toValue:(id)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = toValue;
    animation.beginTime = beginTime;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    return animation;
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
    GTBallLoadingHorizontalSwitch *loading = [[GTBallLoadingHorizontalSwitch alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    [loading start];
}

+ (void)hideInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[GTBallLoadingHorizontalSwitch class]]) {
            [(GTBallLoadingHorizontalSwitch *)subView dismiss];
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
        _ball1.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    }
    return _ball1;
}

- (UIView *)ball2 {
    if (!_ball2) {
        _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2, _ballContainer.bounds.size.height/2);
        _ball2.layer.cornerRadius = ballWidth/2;
        _ball2.backgroundColor =  [UIColor colorWithRed:225/255.0 green:43/255.0 blue:60/255.0 alpha:1];
    }
    return _ball2;
}

- (UIView *)ball3 {
    if (!_ball3) {
        _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball3.center = CGPointMake(_ballContainer.bounds.size.width-ballWidth/2, _ballContainer.bounds.size.height/2);
        _ball3.layer.cornerRadius = ballWidth/2;
        _ball3.backgroundColor = [UIColor colorWithRed:45/255.0 green:110/255.0 blue:250/255.0 alpha:1];
    }
    return _ball3;
}

@end
