//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCircleButton.h"


@implementation HTLCircleButton

- (void)configure {
    self.layer.cornerRadius = self.bounds.size.height / 2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

@end