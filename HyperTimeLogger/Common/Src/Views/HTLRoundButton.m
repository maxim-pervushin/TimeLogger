//
// Created by Maxim Pervushin on 23/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLRoundButton.h"


static const int kButtonCornerRadius = 5;

@implementation HTLRoundButton

- (void)configure {
    self.layer.cornerRadius = kButtonCornerRadius;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

@end