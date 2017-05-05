//
//  FaveButton.h
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaveButton;

@protocol FaveButtonDelegate <NSObject>

- (void)faveButton:(FaveButton *)faveButton didSelect:(BOOL)didSelect;

- (NSArray<NSArray<UIColor *> *> *)faveButtonColors:(FaveButton *)faveButton;

@end

@interface FaveButton : UIButton

/// default : (137, 156, 167)
@property (nonatomic, strong) IBInspectable UIColor *normalColor;
/// default : (226, 38, 77)
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;
/// default : (152, 219, 236)
@property (nonatomic, strong) IBInspectable UIColor *dotFirstColor;
/// default : (247, 188, 48)
@property (nonatomic, strong) IBInspectable UIColor *dotSecondColor;
/// default : (221, 70, 136)
@property (nonatomic, strong) IBInspectable UIColor *circleFromColor;
/// default : (205, 143, 246)
@property (nonatomic, strong) IBInspectable UIColor *circleToColor;


@property (nonatomic, weak) IBOutlet id<FaveButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame faveIconNormal:(UIImage *)image;

@end
