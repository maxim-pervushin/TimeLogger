//
// Created by Maxim Pervushin on 10/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedDto.h"


@interface HTLReportExtendedDto (Helpers)

- (NSTimeInterval)duration;

- (NSString *)durationString;

- (NSString *)startDateString;

- (NSString *)endDateString;

@end
