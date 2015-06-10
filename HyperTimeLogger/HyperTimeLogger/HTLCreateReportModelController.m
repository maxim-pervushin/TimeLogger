//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCreateReportModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"


@implementation HTLCreateReportModelController

#pragma mark - HTLCreateReportModelController

- (NSArray *)getCompletionsForText:(NSString *)text {
    return [[HTLContentManager defaultManager] completionsForText:text];
}

- (NSArray *)getCategories {
    return [[HTLContentManager defaultManager] categories];
}

- (BOOL)createReportExtended:(HTLReportExtendedDto *)reportExtended {
    if (!reportExtended) {
        return NO;
    }

    return [[HTLContentManager defaultManager] addReportExtended:reportExtended];
}

- (NSDate *)lastReportEndDate {
    NSDate *date = [HTLContentManager defaultManager].lastReportEndDate;
    return date ? date : [NSDate new];
}

@end