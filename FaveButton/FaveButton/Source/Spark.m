//
//  Spark.m
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

#import "Spark.h"
#import "FaveButton.h"

static CGFloat const verticalDistance   = 4.0f;
static CGFloat const horizontalDistance = 0.0f;

static NSString *const expandKey  = @"expandKey";
static NSString *const dotSizeKey = @"dotSizeKey";

@interface Spark ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, strong) UIColor *secondColor;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) CGFloat firstDotRadius;
@property (nonatomic, assign) CGFloat secondDotRadius;

@property (nonatomic, strong) UIView *dotFirst;
@property (nonatomic, strong) UIView *dotSecond;

@property (nonatomic, strong) NSLayoutConstraint *distanceConstraint;

@end

@implementation Spark

+ (instancetype)sparkWithFaveButton:(FaveButton *)faveButton
                             radius:(CGFloat)radius
                         firstColor:(UIColor *)firstColor
                        secondColor:(UIColor *)secondColor
                              angle:(CGFloat)angle
                     firstDotRadius:(CGFloat)firstDotRadius
                    secondDotRadius:(CGFloat)secondDotRadius
{
    Spark *spark = [[self alloc] initWithRadius:radius firstColor:firstColor secondColor:secondColor angle:angle firstDotRadius:firstDotRadius secondDotRadius:secondDotRadius];
    
    spark.translatesAutoresizingMaskIntoConstraints = NO;
    spark.backgroundColor   = [UIColor clearColor];
    spark.layer.anchorPoint = CGPointMake(0.5, 1);
    spark.alpha = 0.0f;
    
    [faveButton.superview insertSubview:spark belowSubview:faveButton];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintWitdh   = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintHeight  = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    constraintWitdh.constant    = (firstDotRadius + secondDotRadius) * 2.0 + horizontalDistance;
    constraintHeight.constant   = (firstDotRadius + secondDotRadius) * 2.0 + radius;
    constraintHeight.identifier = expandKey;
    
    [NSLayoutConstraint activateConstraints:@[constraintCenterX, constraintCenterY, constraintWitdh, constraintHeight]];
    
    return spark;
}

- (instancetype)initWithRadius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle firstDotRadius:(CGFloat)firstDotRadius secondDotRadius:(CGFloat)secondDotRadius
{
    self = [super init];
    if (self)
    {
        _radius          = radius;
        _firstColor      = firstColor;
        _secondColor     = secondColor;
        _angle           = angle;
        _firstDotRadius  = firstDotRadius;
        _secondDotRadius = secondDotRadius;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.dotFirst  = [self dotViewWithRadius:self.firstDotRadius fillColor:self.firstColor];
    self.dotSecond = [self dotViewWithRadius:self.secondDotRadius fillColor:self.secondColor];
    
    [self addContraintForDot:self.dotFirst first:YES];
    [self addContraintForDot:self.dotSecond first:NO];
    
    self.distanceConstraint = [NSLayoutConstraint constraintWithItem:self.dotFirst attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.dotSecond attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    self.distanceConstraint.active = YES;
    
    self.transform = CGAffineTransformMakeRotation(self.angle / 180.0 * M_PI);
}

- (UIView *)dotViewWithRadius:(CGFloat)radius fillColor:(UIColor *)fillColor
{
    return ({
        UIView *view = [UIView new];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor    = fillColor;
        view.layer.cornerRadius = radius;
        
        [self addSubview:view];
        
        view;
    });
}

- (void)addContraintForDot:(UIView *)dotView first:(BOOL)isFirst
{
    NSMutableArray *constraintsNeedActive = [NSMutableArray array];
    
    CGFloat dotSide = 2 * (isFirst ? self.firstDotRadius : self.secondDotRadius);
    
    NSLayoutConstraint *constraintWidth   = [NSLayoutConstraint constraintWithItem:dotView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSide];
    NSLayoutConstraint *constraintHeight  = [NSLayoutConstraint constraintWithItem:dotView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSide];
    constraintWidth.identifier  = dotSizeKey;
    constraintHeight.identifier = dotSizeKey;
    
    [constraintsNeedActive addObjectsFromArray:@[constraintWidth, constraintHeight]];
    
    if (isFirst)
    {
        [constraintsNeedActive addObject:[NSLayoutConstraint constraintWithItem:dotView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }
    else
    {
        [constraintsNeedActive addObject:[NSLayoutConstraint constraintWithItem:dotView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [constraintsNeedActive addObject:[NSLayoutConstraint constraintWithItem:dotView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.firstDotRadius * 2 + verticalDistance]];
    }
    
    [NSLayoutConstraint activateConstraints:constraintsNeedActive];
}

@end

@implementation Spark (Animations)

- (void)animateIgniteShowWithRadius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [self layoutIfNeeded];
    
    CGFloat diameter = (self.firstDotRadius + self.secondDotRadius) * 2;
    CGFloat height   = radius + diameter + verticalDistance;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", expandKey];
    [[self.constraints filteredArrayUsingPredicate:predicate] firstObject].constant = height;
    
    [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0f;
    } completion:nil];
    
    [UIView animateWithDuration:duration * 0.7 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)animateIgniteHideWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [self layoutIfNeeded];
    
    self.distanceConstraint.constant = -verticalDistance;
    
    [UIView animateWithDuration:duration * 0.5 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dotSecond.backgroundColor = self.firstColor;
        self.dotFirst.backgroundColor  = self.secondColor;
    } completion:nil];
    
    for (UIView *dot in @[self.dotFirst, self.dotSecond])
    {
        [dot setNeedsLayout];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", dotSizeKey];
        [[dot.constraints filteredArrayUsingPredicate:predicate] enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.constant = 0;
        }];
    }
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.dotSecond layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:duration * 1.7 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.dotFirst layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
