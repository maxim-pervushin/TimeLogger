//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTextField.h"


@implementation HTLTextField

- (void)configure {
    [self enableMaterialPlaceHolder:YES];
    self.errorColor = [UIColor paperColorRed];
    self.lineColor = [UIColor paperColorBrown];
    self.tintColor = [UIColor paperColorBrown];
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