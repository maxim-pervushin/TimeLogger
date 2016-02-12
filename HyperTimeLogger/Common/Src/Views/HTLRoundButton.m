//
// Created by Maxim Pervushin on 23/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLRoundButton.h"


static const int kButtonCornerRadius = 3;

@implementation HTLRoundButton

- (void)configure {
    self.layer.cornerRadius = kButtonCornerRadius;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

@end