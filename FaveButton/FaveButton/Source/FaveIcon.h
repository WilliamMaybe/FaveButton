//
//  FaveIcon.h
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaveIcon : UIView

+ (instancetype)faveIconOnView:(UIView *)view icon:(UIImage *)icon color:(UIColor *)color;

- (void)animateSelect:(BOOL)isSelect fillColor:(UIColor *)color duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end
