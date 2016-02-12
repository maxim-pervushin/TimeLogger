//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportDataSource.h"
#import "HTLDataManager.h"
#import "HTLReportExtended.h"
#import "HTLAction.h"
#import "HTLAppDelegate.h"


@implementation HTLEditReportDataSource
@dynamic categories;
@dynamic startDate;

#pragma mark - HTLEditReportDataSource

- (NSArray *)categories {
    return [HTLAppDataManger findCategoriesWithDateSection:nil];
}

- (NSDate *)startDate {
    return [HTLAppDataManger findLastReportEndDate];
}

- (NSArray *)completionsForAction:(HTLAction *)action {
    if (!action) {
        return [HTLAppDataManger findCompletionsWithText:nil];
    }
    return [HTLAppDataManger findCompletionsWithText:action.title];
}

- (BOOL)saveReportExtended:(HTLReportExtended *)reportExtended {
    return [HTLAppDataManger storeReportExtended:reportExtended];
}

@end