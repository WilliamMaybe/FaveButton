//
//  FaveButton+Private.h
//  FaveButton
//
//  Created by William Zhang on 16/7/7.
//  Copyright © 2016年 money. All rights reserved.
//

#import "FaveButton.h"

@interface FaveButton (Actions)

- (void)addActions;

@end

@interface FaveButton (Animations)

- (void)animateSelect:(BOOL)isSelect duration:(NSTimeInterval)duration;

@end
