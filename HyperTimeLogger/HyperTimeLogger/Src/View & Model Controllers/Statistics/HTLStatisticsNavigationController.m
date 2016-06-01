//
// Created by Maxim Pervushin on 01/06/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsNavigationController.h"
#import "HTLStatisticsViewController.h"


@implementation HTLStatisticsNavigationController
@dynamic dateSection;

- (HTLDateSection *)dateSection {
    return self.viewController.dateSection;
}

- (void)setDateSection:(HTLDateSection *)dateSection {
    self.viewController.dateSection = dateSection;
}

- (HTLStatisticsViewController *)viewController {
    for (UIViewController *child in self.viewControllers) {
        if ([child isKindOfClass:HTLStatisticsViewController.class]) {
            return (HTLStatisticsViewController *) child;
        }
    }
    return nil;
}

@end