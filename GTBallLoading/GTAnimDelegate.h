//
//  GTAnimDelegate.h
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/21.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTAnimDelegateDelegate<NSObject>

@optional
- (void)animationDidStart;
- (void)animationDidStop;
@end

@interface GTAnimDelegate : NSObject<CAAnimationDelegate>

@property (nonatomic, weak) id<GTAnimDelegateDelegate> delegate;

@end
