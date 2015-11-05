//
// Created by Maxim Pervushin on 03/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLLineView.h"


@implementation HTLLineView

- (CGFloat)thickness {
    return (CGFloat) (1.0 / [[UIScreen mainScreen] scale]);
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = self.thickness;
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [super setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat hairline = self.thickness;
    if (size.width > size.height) {
        size.height = hairline;
    } else {
        size.width = hairline;
    }
    return size;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.thickness);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
}

@end
