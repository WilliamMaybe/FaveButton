//
//  FaveButton.m
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import "FaveButton.h"
#import "Ring.h"
#import "Spark.h"
#import "FaveIcon.h"
#import "UIColor+Helper.h"
#import "FaveButton+Private.h"

@interface FaveButton (Const)

@property (nonatomic, readonly) CGFloat duration;
@property (nonatomic, readonly) CGFloat expandDuration;
@property (nonatomic, readonly) CGFloat collapseDuration;
@property (nonatomic, readonly) CGFloat faveIconShowDelay;
@property (nonatomic, readonly) CGFloat firstDotRadius;
@property (nonatomic, readonly) CGFloat secondDotRadius;

@property (nonatomic, readonly) NSInteger sparkGroupCount;

@end

@interface FaveButton ()

@property (nonatomic, strong) UIImage *faveIconImage;
@property (nonatomic, strong) FaveIcon *faveIcon;

@end

@implementation FaveButton

- (instancetype)initWithFrame:(CGRect)frame faveIconNormal:(UIImage *)image
{
    if (!image)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"missing image for normal state" userInfo:nil];
    }
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _faveIconImage = image;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (!self.faveIconImage)
    {
        self.faveIconImage = [self imageForState:UIControlStateNormal];
    }
    
    if (!self.faveIconImage)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"please provide an image for normal state." userInfo:nil];
    }
    
    [self setImage:[UIImage new] forState:UIControlStateNormal];
    [self setImage:[UIImage new] forState:UIControlStateSelected];
    [self setTitle:nil forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateSelected];
    
    self.faveIcon = [FaveIcon faveIconOnView:self icon:self.faveIconImage color:self.normalColor];
    [self addActions];
}

- (NSArray<Spark *> *)sparksWithRadius:(CGFloat)radius
{
    NSMutableArray *sparks = [NSMutableArray array];
    
    CGFloat step            = 360.0 / self.sparkGroupCount;
    CGFloat base            = self.bounds.size.width;
    CGFloat firstDotRadius  = base * self.firstDotRadius;
    CGFloat secondDotRadius = base * self.secondDotRadius;
    CGFloat offset          = 10.0f;
    
    for (NSInteger i = 0; i < self.sparkGroupCount; i ++)
    {
        CGFloat theta = step * i + offset;
        NSArray<UIColor *> *colors = [self dotColorsAtIndex:i];
        
        Spark *spark = [Spark sparkWithFaveButton:self radius:radius firstColor:[colors firstObject] secondColor:colors[1] angle:theta firstDotRadius:firstDotRadius secondDotRadius:secondDotRadius];
        [sparks addObject:spark];
    }
    
    return sparks;
}

- (NSArray<UIColor *> *)dotColorsAtIndex:(NSInteger)index
{
    NSArray *defaultColors = @[self.dotFirstColor, self.dotSecondColor];
    if (![self.delegate respondsToSelector:@selector(faveButtonColors:)])
    {
        return defaultColors;
    }
    
    NSArray *colorsArray = [self.delegate faveButtonColors:self];
    if ([colorsArray count] == 0)
    {
        return defaultColors;
    }
    
    NSInteger colorIndex = index % [colorsArray count];
    NSArray *colors = colorsArray[colorIndex];
    if ([colors count] < 2)
    {
        return defaultColors;
    }
    
    return colors;
}

#pragma mark - Setters
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self animateSelect:selected duration:self.duration];
}

@end

@implementation FaveButton (Actions)

- (void)addActions
{
    [self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggle:(FaveButton *)sender
{
    sender.selected ^= 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        if ([self.delegate respondsToSelector:@selector(faveButton:didSelect:)])
        {
            [self.delegate faveButton:self didSelect:sender.selected];
        }
        
    });
}

@end

@implementation FaveButton (Animations)

- (void)animateSelect:(BOOL)isSelect duration:(NSTimeInterval)duration
{
    UIColor *color = isSelect ? self.selectedColor : self.normalColor;
    
    [self.faveIcon animateSelect:isSelect fillColor:color duration:self.duration delay:self.faveIconShowDelay];
    
    if (!isSelect)
    {
        return;
    }
    
    CGFloat radius           = CGRectGetWidth(self.bounds) * 1.3 / 2;
    CGFloat igniteFromRadius = radius * 0.8;
    CGFloat igniteToRadius   = radius * 1.1;
    
    Ring *ring = [Ring ringWithFaveButton:self radius:0.01 lineWidth:3 fillColor:self.circleFromColor];
    [ring animateToRadius:radius toColor:self.circleToColor duration:self.expandDuration delay:0];
    [ring animateCollapseWithRadius:radius duration:self.collapseDuration delay:self.expandDuration];
    
    NSArray<Spark *> *sparks = [self sparksWithRadius:igniteFromRadius];
    [sparks enumerateObjectsUsingBlock:^(Spark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj animateIgniteShowWithRadius:igniteToRadius duration:0.4 delay:self.collapseDuration / 3.0];
        [obj animateIgniteHideWithDuration:0.7 delay:0.2];
    }];
}

@end

/**
 *  Initialize Configuration
 */
@implementation FaveButton (Configuration)

- (CGFloat)duration             { return 1.0;    }
- (CGFloat)expandDuration       { return 0.1298; }
- (CGFloat)collapseDuration     { return 0.1089; }
- (CGFloat)faveIconShowDelay    { return self.expandDuration + self.collapseDuration / 2.0; }
- (CGFloat)firstDotRadius       { return 0.0633; }
- (CGFloat)secondDotRadius      { return 0.04;   }

- (NSInteger)sparkGroupCount { return 7; }

- (UIColor *)normalColor
{
    if (!_normalColor)
    {
        _normalColor = [UIColor wz_colorWithR:137 g:156 b:167];
    }
    return _normalColor;
}

- (UIColor *)selectedColor
{
    if (!_selectedColor)
    {
        _selectedColor = [UIColor wz_colorWithR:226 g:38 b:77];
    }
    return _selectedColor;
}

- (UIColor *)dotFirstColor
{
    if (!_dotFirstColor)
    {
        _dotFirstColor = [UIColor wz_colorWithR:152 g:219 b:236];
    }
    return _dotFirstColor;
}

- (UIColor *)dotSecondColor
{
    if (!_dotSecondColor)
    {
        _dotSecondColor = [UIColor wz_colorWithR:247 g:188 b:48];
    }
    return _dotSecondColor;
}

- (UIColor *)circleFromColor
{
    if (!_circleFromColor)
    {
        _circleFromColor = [UIColor wz_colorWithR:221 g:70 b:136];
    }
    return _circleFromColor;
}

- (UIColor *)circleToColor
{
    if (!_circleToColor)
    {
        _circleToColor = [UIColor wz_colorWithR:205 g:143 b:246];
    }
    return _circleToColor;
}

@end
