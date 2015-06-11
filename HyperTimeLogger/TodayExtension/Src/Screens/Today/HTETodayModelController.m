//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTETodayViewController.h"

@implementation HTETodayModelController

- (NSArray *)completions:(NSUInteger)numberOfCompletions {
    NSArray *completions = [[HTLContentManager defaultManager] completionsWithText:nil];
    NSMutableArray *result = [NSMutableArray new];
//    for (NSUInteger i = 0; i < completions.count && i < numberOfCompletions; i++) {
    for (NSUInteger i = 0; i < completions.count && i < numberOfCompletions; i++) {
        [result addObject:completions[i]];
    }
    return [result copy];
}

- (BOOL)createReportExtended:(HTLReportExtendedDto *)reportExtended {
    return [[HTLContentManager defaultManager] addReportExtended:reportExtended];
}

- (NSDate *)lastReportEndDate {
    NSDate *date = [HTLContentManager defaultManager].lastReportEndDate;
    return date ? date : [NSDate new];
}

- (HTLReportExtendedDto *)lastReportExtended {
    return [HTLContentManager defaultManager].lastReportExtended;
}

@end