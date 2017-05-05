//
//  ViewController.m
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import "ViewController.h"
#import "FaveButton.h"
#import "UIColor+Helper.h"

@interface ViewController () <FaveButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faveButton:(FaveButton *)faveButton didSelect:(BOOL)didSelect
{
    
}

- (NSArray<NSArray<UIColor *> *> *)faveButtonColors:(FaveButton *)faveButton
{
    return @[
             @[[UIColor wz_colorWithRGB:0x7dc2f4], [UIColor wz_colorWithRGB:0xe2264d]],
             @[[UIColor wz_colorWithRGB:0xf8cc61], [UIColor wz_colorWithRGB:0x9bdfba]],
             @[[UIColor wz_colorWithRGB:0xaf90f4], [UIColor wz_colorWithRGB:0x90d1f9]],
             @[[UIColor wz_colorWithRGB:0xe9a966], [UIColor wz_colorWithRGB:0xf8c852]],
             @[[UIColor wz_colorWithRGB:0xf68fa7], [UIColor wz_colorWithRGB:0xf6a2b8]]
             ];
}

@end
