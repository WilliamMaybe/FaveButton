//
//  Ring.h
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaveButton;

@interface Ring : UIView

+ (instancetype)ringWithFaveButton:(FaveButton *)faveButton radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor;

@end

@interface Ring (Animations)

- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;
- (void)animateCollapseWithRadius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end
