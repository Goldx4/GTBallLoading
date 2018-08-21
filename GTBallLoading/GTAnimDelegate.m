//
//  GTAnimDelegate.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/21.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "GTAnimDelegate.h"

@implementation GTAnimDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if ([self.delegate respondsToSelector:@selector(animationDidStart)]) {
        [self.delegate animationDidStart];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(animationDidStop)]) {
        [self.delegate animationDidStop];
    }
}

@end
