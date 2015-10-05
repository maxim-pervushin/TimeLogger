//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayDataSource_New.h"
#import "HTLCategory.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"
#import "HTLReportExtended.h"
#import "HTLAction.h"
#import "HTLReport.h"


@implementation HTLTodayDataSource_New

- (NSTimeInterval)currentInterval {
    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        return 0;
    }

    return [[NSDate new] timeIntervalSinceDate:lastReportEndDate];
}

- (NSUInteger)numberOfCategories {
    return [HTLAppContentManger numberOfCategoriesWithDateSection:nil];
}

- (HTLCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath {

    return [HTLAppContentManger categoriesWithDateSection:nil][(NSUInteger) indexPath.row];
}

- (BOOL)saveReportWithCategoryAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategory *category = [self categoryAtIndexPath:indexPath];
    if (!category) {
        return NO;
    }

    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];

    HTLAction *action = [HTLAction actionWithIdentifier:[[NSUUID new] UUIDString]
                                                  title:@""];
    HTLReport *report = [HTLReport reportWithIdentifier:[[NSUUID new] UUIDString]
                                       actionIdentifier:action.identifier
                                     categoryIdentifier:category.identifier
                                              startDate:lastReportEndDate ? lastReportEndDate : [NSDate new]
                                                endDate:[NSDate new]];

    HTLReportExtended *reportExtended = [HTLReportExtended reportExtendedWithReport:report
                                                                             action:action
                                                                           category:category];

    return [HTLAppContentManger saveReportExtended:reportExtended];
}

@end