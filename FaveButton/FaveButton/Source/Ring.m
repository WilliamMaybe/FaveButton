//
//  Ring.m
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

#import "Ring.h"
#import "FaveButton.h"

static NSString *const collapseAnimation = @"collapseAnimation";
static NSString *const sizeKey           = @"sizeKey";

@interface Ring ()

@property (nonatomic, strong) UIColor      *fillColor;
@property (nonatomic, assign) CGFloat      radius;
@property (nonatomic, assign) CGFloat      lineWidth;
@property (nonatomic, strong) CAShapeLayer *ringLayer;

@end

@implementation Ring

+ (instancetype)ringWithFaveButton:(FaveButton *)faveButton radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor
{
    Ring *ring = [[self alloc] initWithRadius:radius lineWidth:lineWidth fillColor:fillColor];
    
    ring.translatesAutoresizingMaskIntoConstraints = NO;
    ring.backgroundColor = [UIColor clearColor];
    
    [faveButton.superview insertSubview:ring belowSubview:faveButton];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintWitdh   = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:radius * 2];
    NSLayoutConstraint *constraintHeight  = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:radius * 2];
    
    [NSLayoutConstraint activateConstraints:@[constraintCenterX, constraintCenterY, constraintWitdh, constraintHeight]];
    
    return ring;
}

- (instancetype)initWithRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor
{
    self = [super init];
    if (self)
    {
        _radius    = radius;
        _lineWidth = lineWidth;
        _fillColor = fillColor;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    centerView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:centerView];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintWitdh   = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintHeight  = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    constraintWitdh.identifier  = sizeKey;
    constraintHeight.identifier = sizeKey;
    [NSLayoutConstraint activateConstraints:@[constraintCenterX, constraintCenterY, constraintWitdh, constraintHeight]];
    
    CAShapeLayer *circle = [self createRingLayer];
    [centerView.layer addSublayer:circle];
    
    self.ringLayer = circle;
}

- (CAShapeLayer *)createRingLayer
{
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.radius - self.lineWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    return ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.path        = circle.CGPath;
        layer.fillColor   = [UIColor clearColor].CGColor;
        layer.lineWidth   = 0;
        layer.strokeColor = self.fillColor.CGColor;
        
        layer;
    });
}

@end


@implementation Ring (Animations)

- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [self layoutIfNeeded];
    
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if ([constraint.identifier isEqualToString:sizeKey])
        {
            constraint.constant = radius * 2;
        }
    }
    
    CGFloat fittedRadius = radius - self.lineWidth / 2;
    
    CABasicAnimation *fillColorAnimation  = [self animationFillColor:self.fillColor toColor:toColor duration:duration delay:delay];
    CABasicAnimation *lineWidthAnimation  = [self animationLineWidth:self.lineWidth duration:duration delay:delay];
    CABasicAnimation *lineColorAnimation  = [self animationStrokeColor:toColor duration:duration delay:delay];
    CABasicAnimation *circlePathAnimation = [self animationCirclePath:fittedRadius duration:duration delay:delay];
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:nil];
    [self.ringLayer addAnimation:fillColorAnimation  forKey:nil];
    [self.ringLayer addAnimation:lineWidthAnimation  forKey:nil];
    [self.ringLayer addAnimation:lineColorAnimation  forKey:nil];
    [self.ringLayer addAnimation:circlePathAnimation forKey:nil];
}

- (void)animateCollapseWithRadius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    CABasicAnimation *lineWidthAnimation = [self animationLineWidth:0 duration:duration delay:delay];
    CABasicAnimation *circlePathAnimation = [self animationCirclePath:radius duration:duration delay:delay];
    
    circlePathAnimation.delegate = self;
    [circlePathAnimation setValue:collapseAnimation forKey:collapseAnimation];
    
    [self.ringLayer addAnimation:lineWidthAnimation forKey:nil];
    [self.ringLayer addAnimation:circlePathAnimation forKey:nil];
}

- (CABasicAnimation *)animationFillColor:(UIColor *)fromColor toColor:(UIColor *)toColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    return ({
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        
        animation.fromValue      = (__bridge id)(fromColor.CGColor);
        animation.toValue        = (__bridge id)(toColor.CGColor);
        animation.duration       = duration;
        animation.beginTime      = CACurrentMediaTime() + delay;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation;
    });
}

- (CABasicAnimation *)animationStrokeColor:(UIColor *)strokeColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    return ({
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        
        animation.toValue             = (__bridge id)(strokeColor.CGColor);
        animation.duration            = duration;
        animation.beginTime           = CACurrentMediaTime() + delay;
        animation.fillMode            = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation;
    });
}

- (CABasicAnimation *)animationLineWidth:(CGFloat)lineWidth duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    return ({
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        
        animation.toValue             = @(lineWidth);
        animation.duration            = duration;
        animation.beginTime           = CACurrentMediaTime() + delay;
        animation.fillMode            = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation;
    });
}

- (CABasicAnimation *)animationCirclePath:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    return ({
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
        
        animation.toValue             = (__bridge id)(path.CGPath);
        animation.duration            = duration;
        animation.beginTime           = CACurrentMediaTime() + delay;
        animation.fillMode            = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation;
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim valueForKey:collapseAnimation])
    {
        [self removeFromSuperview];
    }
}

@end
