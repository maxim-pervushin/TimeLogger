//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportDataSource.h"
#import "HTLApp.h"
#import "HTLDataManager.h"
#import "HTLReportExtended.h"
#import "HTLAction.h"


@implementation HTLEditReportDataSource
@dynamic categories;
@dynamic startDate;

#pragma mark - HTLEditReportDataSource

- (NSArray *)categories {
    return [[HTLApp dataManager] findCategoriesWithDateSection:nil];
}

- (NSDate *)startDate {
    return [[HTLApp dataManager] findLastReportEndDate];
}

- (NSArray *)completionsForAction:(HTLAction *)action {
    if (!action) {
        return [[HTLApp dataManager] findCompletionsWithText:nil];
    }
    return [[HTLApp dataManager] findCompletionsWithText:action.title];
}

- (BOOL)saveReportExtended:(HTLReportExtended *)reportExtended {
    return [[HTLApp dataManager] storeReportExtended:reportExtended];
}

@end