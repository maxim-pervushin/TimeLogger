//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLModelController.h"

@class HTLCompletionDto;
@class HTLReportExtendedDto;

@interface HTETodayModelController : HTLModelController

- (NSArray *)completions:(NSUInteger)numberOfCompletions;

- (BOOL)createReportWithCompletion:(HTLCompletionDto *)completion;

- (HTLReportExtendedDto *)lastReportExtended;

@end
