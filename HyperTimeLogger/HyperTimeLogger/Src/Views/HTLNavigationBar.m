//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLNavigationBar.h"


@interface HTLNavigationBar ()

- (void)initializeUI;

@end

@implementation HTLNavigationBar

#pragma mark - HTLNavigationBar

- (void)initializeUI {
    self.barTintColor = [UIColor blackColor];
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