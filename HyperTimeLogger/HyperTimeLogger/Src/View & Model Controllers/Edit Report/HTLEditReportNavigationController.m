//
// Created by Maxim Pervushin on 01/06/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportNavigationController.h"
#import "HTLReportExtended.h"
#import "HTLEditReportViewController.h"


@implementation HTLEditReportNavigationController
@dynamic reportExtended;

- (HTLReportExtended *)reportExtended {
    return self.viewController.reportExtended;
}

- (void)setReportExtended:(HTLReportExtended *)reportExtended {
    self.viewController.reportExtended = reportExtended;
}

- (HTLEditReportViewController *)viewController {
    for (UIViewController *child in self.viewControllers) {
        if ([child isKindOfClass:HTLEditReportViewController.class]) {
            return (HTLEditReportViewController *) child;
        }
    }
    return nil;
}

@end