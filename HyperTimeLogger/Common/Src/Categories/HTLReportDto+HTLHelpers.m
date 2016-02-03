//
// Created by Maxim Pervushin on 10/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDto+HTLHelpers.h"

@implementation HTLReportDto (HTLHelpers)

- (NSTimeInterval)duration {
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

@end