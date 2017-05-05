//
//  UIColor+Helper.h
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)wz_colorWithR:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue;
+ (UIColor *)wz_colorWithR:(NSInteger)red g:(NSInteger)green b:(NSInteger)blue alpha:(CGFloat)alpha;

+ (UIColor *)wz_colorWithRGB:(NSInteger)rgb;
+ (UIColor *)wz_colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

@end
