//
// Created by Maxim Pervushin on 10/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport+Helpers.h"
#import "HTLMark.h"

@implementation HTLReport (Helpers)

- (NSTimeInterval)duration {
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

//- (NSString *)durationString {
//    NSInteger ti = (NSInteger) self.duration;
//    NSInteger seconds = ti % 60;
//    NSInteger minutes = (ti / 60) % 60;
//    NSInteger hours = (ti / 3600);
//    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
//                    (long) hours, (long) minutes, (long) seconds];
//}

@end