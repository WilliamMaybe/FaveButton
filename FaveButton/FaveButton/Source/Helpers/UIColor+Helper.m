//
//  UIColor+Helper.m
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)wz_colorWithR:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue
{
    return [self wz_colorWithR:red g:green b:blue alpha:1.0];
}

+ (UIColor *)wz_colorWithR:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)wz_colorWithRGB:(NSInteger)rgb { return [self wz_colorWithRGB:rgb alpha:1.0]; }

+ (UIColor *)wz_colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgb & 0xFF)) / 255.0
                           alpha:(alpha)];
}

@end
