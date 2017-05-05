//
//  FaveIcon.m
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import "FaveIcon.h"
#import "Easing.h"

@interface FaveIcon ()

@property (nonatomic, strong) UIColor      *iconColor;
@property (nonatomic, strong) UIImage      *iconImage;
@property (nonatomic, strong) CAShapeLayer *iconLayer;
@property (nonatomic, strong) CALayer      *iconMask;
@property (nonatomic, assign) CGRect       contentRegion;
@property (nonatomic, strong) NSArray<NSNumber *> *tweenValues;


@end

@implementation FaveIcon

+ (instancetype)faveIconOnView:(UIView *)view icon:(UIImage *)icon color:(UIColor *)color
{
    FaveIcon *faveIcon = [[self alloc] initWithRegion:view.bounds icon:icon color:color];
    
    faveIcon.translatesAutoresizingMaskIntoConstraints = NO;
    faveIcon.backgroundColor = [UIColor clearColor];
    
    [view addSubview:faveIcon];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintWitdh   = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintHeight  = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    [NSLayoutConstraint activateConstraints:@[constraintCenterX, constraintCenterY, constraintWitdh, constraintHeight]];
    
    return faveIcon;
}

- (instancetype)initWithRegion:(CGRect)region icon:(UIImage *)icon color:(UIColor *)color
{
    self = [super init];
    if (self)
    {
        _contentRegion = region;
        _iconImage     = icon;
        _iconColor     = color;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    CGPoint contentRegionCenter = CGPointMake(self.contentRegion.size.width / 2.0, self.contentRegion.size.height / 2.0);
    CGSize scaledRegionSize = CGSizeMake(self.contentRegion.size.width * 0.7, self.contentRegion.size.height * 0.7);
    
    CGRect maskRegion   = CGRectMake(contentRegionCenter.x - scaledRegionSize.width / 2.0, contentRegionCenter.y - scaledRegionSize.height / 2.0, scaledRegionSize.width, scaledRegionSize.height);
    CGPoint shapeOrigin = CGPointMake(-contentRegionCenter.x, -contentRegionCenter.y);
    
    self.iconMask =
    ({
        CALayer *layer = [CALayer layer];
        
        layer.contents = (__bridge id)(self.iconImage.CGImage);
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.bounds = maskRegion;
        
        layer;
    });
    
    self.iconLayer =
    ({
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.contents  = (__bridge id)(self.iconImage.CGImage);
        shapeLayer.fillColor = self.iconColor.CGColor;
        shapeLayer.path      = [UIBezierPath bezierPathWithRect:CGRectMake(shapeOrigin.x, shapeOrigin.y, CGRectGetWidth(self.contentRegion), CGRectGetHeight(self.contentRegion))].CGPath;
        shapeLayer.mask      = self.iconMask;
        
        shapeLayer;
    });
    
    [self.layer addSublayer:self.iconLayer];
}

- (void)animateSelect:(BOOL)isSelect fillColor:(UIColor *)color duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.iconLayer.fillColor = color.CGColor;
    [CATransaction commit];
    
    NSTimeInterval selectedDelay = isSelect ? delay : 0;
    
    if (isSelect)
    {
        self.alpha = 0.0f;
        [UIView animateWithDuration:0
                              delay:selectedDelay
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.alpha = 1.0;
                         }
                         completion:nil];
    }
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.values = [self generateTweenValuesFrom:0 to:1.0f duration:duration];
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = CACurrentMediaTime() + selectedDelay;
    [self.iconMask addAnimation:scaleAnimation forKey:nil];
}

- (NSMutableArray<NSNumber *> *)generateTweenValuesFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration
{
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
    
    CGFloat fps = 60.0;// frame per second
    CGFloat tpf = duration / fps;
    CGFloat c   = toValue - fromValue;
    CGFloat d   = duration;
    CGFloat t   = 0.0;
    
    while (t < d)
    {
        CGFloat scale = [Easing extendedEaseOutWithT:t b:fromValue c:c d:d a:c + 0.001 p:0.399988]; // p = oscillations, c = amplitude(velocity)
        [numbers addObject:@(scale)];
        t += tpf;
    }
    
    return numbers;
}

@end
