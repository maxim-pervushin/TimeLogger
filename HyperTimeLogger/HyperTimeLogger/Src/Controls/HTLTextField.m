//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTextField.h"


@implementation HTLTextField

- (void)configure {
    [self enableMaterialPlaceHolder:YES];
    self.errorColor = [UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    self.lineColor = [UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.tintColor = [UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

@end