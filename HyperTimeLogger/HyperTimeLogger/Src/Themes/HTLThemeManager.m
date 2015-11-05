//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLThemeManager.h"
#import "HTLRoundButton.h"


@implementation HTLThemeManager

- (void)setTheme:(HTLTheme *)theme {

    // HTLRoundButton

    [HTLRoundButton appearance].titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    [HTLRoundButton appearance].backgroundColor = theme.controlBackgroundColor;
    [[HTLRoundButton appearance] setTitleColor:theme.normalControlTitleColor forState:UIControlStateNormal];
    [[HTLRoundButton appearance] setTitleColor:theme.normalControlTitleColor forState:UIControlStateSelected];
    [[HTLRoundButton appearance] setTitleColor:theme.disabledControlTitleColor forState:UIControlStateDisabled];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTheme:[HTLTheme new]];
    }
    return self;
}

@end

@implementation HTLTheme : NSObject

- (UIColor *)controlBackgroundColor {
    return [UIColor paperColorYellow];
}

- (UIColor *)normalControlTitleColor {
    return [UIColor blackColor];
}

- (UIColor *)disabledControlTitleColor {
    return [UIColor paperColorGray50];
}

@end
