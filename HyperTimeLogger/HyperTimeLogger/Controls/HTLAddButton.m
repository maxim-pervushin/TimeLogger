//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAddButton.h"


@implementation HTLAddButton

- (void)configure {
    [super configure];

    [self setBackgroundColor:[UIColor paperColorBlue]];
    [self setTintColor:[UIColor whiteColor]];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateSelected];
}

@end