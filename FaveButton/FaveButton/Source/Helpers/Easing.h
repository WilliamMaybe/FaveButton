//
//  Easing.h
//  FaveButton
//
//  Created by William Zhang on 16/7/8.
//  Copyright © 2016年 money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Easing : NSObject

+ (CGFloat)extendedEaseOutWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p;

@end
