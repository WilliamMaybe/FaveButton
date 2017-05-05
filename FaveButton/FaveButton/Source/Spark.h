//
//  Spark.h
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaveButton;

@interface Spark : UIView

+ (instancetype)sparkWithFaveButton:(FaveButton *)faveButton
                             radius:(CGFloat)radius
                         firstColor:(UIColor *)firstColor
                        secondColor:(UIColor *)secondColor
                              angle:(CGFloat)angle
                     firstDotRadius:(CGFloat)firstDotRadius
                    secondDotRadius:(CGFloat)secondDotRadius;

@end

@interface Spark (Animations)

- (void)animateIgniteShowWithRadius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;
- (void)animateIgniteHideWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end
