//
//  Easing.m
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

// file taken from https://github.com/xhamr/swift-penner-easing-functions

#import "Easing.h"

@implementation Easing

+ (CGFloat)extendedEaseOutWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p
{
    CGFloat s = 0.0f;
    
    if (t == 0) return b;
    
    t /= d;
    if (t == 1) return b + c;
    
    if (a < fabs(c))
    {
        a = c;
        s = p / 4;
    }
    else
    {
        s = p / (2 * M_PI) * asin(c / a);
    }
    
    return a * pow(2, -10 * t) * sin((t * d - s) * 2 * M_PI / p) + c + b;
}

@end
