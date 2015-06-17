//
// Created by Maxim Pervushin on 03/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLBackgroundView.h"
#import "UIColor+BFPaperColors.h"


@interface HTLBackgroundView ()

- (void)initializeUI;

@end

@implementation HTLBackgroundView

#pragma mark - HTLBackgroundView

- (void)initializeUI {
    self.backgroundColor = [UIColor paperColorGray700];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeUI];
    }
    return self;
}

@end