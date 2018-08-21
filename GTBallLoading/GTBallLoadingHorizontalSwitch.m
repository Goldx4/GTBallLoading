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
static const NSTimeInterval animateDuration = 1.f;

@interface GTBallLoadingHorizontalSwitch()<GTAnimDelegateDelegate>
// ball's container
@property (nonatomic, strong) UIVisualEffectView *ballContainer;
// first ball
@property (nonatomic, strong) UIView *ball1;
// second ball
@property (nonatomic, strong) UIView *ball2;
// third ball
@property (nonatomic, strong) UIView *ball3;
// first ball's color
@property (nonatomic, strong) UIColor *ball1Color;
// second ball's color
@property (nonatomic, strong) UIColor *ball2Color;
// third ball's color
@property (nonatomic, strong) UIColor *ball3Color;
// whether should hide the balls
@property (nonatomic, assign, getter=isShouldDismiss) BOOL shouldDismiss;
@end

@implementation GTBallLoadingHorizontalSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.ball1Color = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        self.ball2Color = [UIColor colorWithRed:225/255.0 green:43/255.0 blue:60/255.0 alpha:1];
        self.ball3Color = [UIColor colorWithRed:45/255.0 green:110/255.0 blue:250/255.0 alpha:1];
        
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

- (void)animationDidStart:(CAAnimation *)anim {
    
    // 每次动画开始后 找准时机变换球的颜色
    // 初始状态 (灰) (红) (蓝)
    // 变动状态 (红) (蓝) (灰)
    // 变动状态 (蓝) (灰) (红)
    // 恢复状态 (灰) (红) (蓝)
    
    CGFloat delay = animateDuration/2;
    static NSInteger switchTimes = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (switchTimes == 0) {
            
            switchTimes = 1;
            self.ball1.backgroundColor = self.ball1Color;
            self.ball2.backgroundColor = self.ball3Color;
            self.ball3.backgroundColor = self.ball2Color;
            
        } else if (switchTimes == 1) {
            
            switchTimes = 2;
            self.ball1.backgroundColor = self.ball3Color;
            self.ball2.backgroundColor = self.ball1Color;
            self.ball3.backgroundColor = self.ball2Color;
            
        } else if (switchTimes == 2) {
            
            switchTimes = 0;
            self.ball1.backgroundColor = self.ball1Color;
            self.ball2.backgroundColor = self.ball2Color;
            self.ball3.backgroundColor = self.ball3Color;
            
        }
        
    });
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
    CGFloat r = ballWidth/2;
    
    // 共三次变换
    // 初始状态 1(灰) 2(红) 3(蓝)
    // 变动状态 2(红) 3(蓝) 1(灰)
    // 变动状态 3(蓝) 1(灰) 2(红)
    // 恢复状态 1(灰) 2(红) 3(蓝)
    // 经观察百度的效果，2不动，1和3相互变动，变动时改变球的颜色
    
    static BOOL isSwitched = false;
    if (!isSwitched) {
        isSwitched = true;
        CABasicAnimation *animation1_1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation1_1.fromValue = @(r);
        animation1_1.toValue = @(width-r);
        animation1_1.duration = animateDuration;
        animation1_1.removedOnCompletion = NO;
        animation1_1.fillMode = kCAFillModeForwards;
        [_ball1.layer addAnimation:animation1_1 forKey:nil];
        
        CABasicAnimation *animation3_1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation3_1.fromValue = @(width-r);
        animation3_1.toValue = @(r);
        animation3_1.duration = animateDuration;
        animation3_1.removedOnCompletion = NO;
        animation3_1.fillMode = kCAFillModeForwards;
        
        GTAnimDelegate *animDelegate = [[GTAnimDelegate alloc] init];
        animDelegate.delegate = self;
        animation3_1.delegate = animDelegate;
        
        [_ball3.layer addAnimation:animation3_1 forKey:@"animation3"];
        
    } else {
        isSwitched = false;
        CABasicAnimation *animation1_1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation1_1.fromValue = @(width-r);
        animation1_1.toValue = @(r);
        animation1_1.duration = animateDuration;
        animation1_1.removedOnCompletion = NO;
        animation1_1.fillMode = kCAFillModeForwards;
        [_ball1.layer addAnimation:animation1_1 forKey:nil];
        
        CABasicAnimation *animation3_1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation3_1.fromValue = @(r);
        animation3_1.toValue = @(width-r);
        animation3_1.duration = animateDuration;
        animation3_1.removedOnCompletion = NO;
        animation3_1.fillMode = kCAFillModeForwards;
        
        GTAnimDelegate *animDelegate = [[GTAnimDelegate alloc] init];
        animDelegate.delegate = self;
        animation3_1.delegate = animDelegate;
        
        [_ball3.layer addAnimation:animation3_1 forKey:@"animation3"];
    }
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
        _ball1.backgroundColor = self.ball1Color;
    }
    return _ball1;
}

- (UIView *)ball2 {
    if (!_ball2) {
        _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2, _ballContainer.bounds.size.height/2);
        _ball2.layer.cornerRadius = ballWidth/2;
        _ball2.backgroundColor = self.ball2Color;
    }
    return _ball2;
}

- (UIView *)ball3 {
    if (!_ball3) {
        _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
        _ball3.center = CGPointMake(_ballContainer.bounds.size.width-ballWidth/2, _ballContainer.bounds.size.height/2);
        _ball3.layer.cornerRadius = ballWidth/2;
        _ball3.backgroundColor = self.ball3Color;
    }
    return _ball3;
} 

@end
