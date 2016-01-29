//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTLActionDto.h"
#import "HTLAppDelegate.h"


@implementation HTLEditReportModelController
@dynamic categories;
@dynamic startDate;

#pragma mark - HTLCreateReportModelController

- (NSArray *)categories {
    return [HTLAppContentManger findCategoriesWithDateSection:nil];
}

- (NSDate *)startDate {
    return [HTLAppContentManger findLastReportEndDate];
}

- (NSArray *)completionsForAction:(HTLActionDto *)action {
    if (!action) {
        return [HTLAppContentManger findCompletionsWithText:nil];
    }
    return [HTLAppContentManger findCompletionsWithText:action.title];
}

- (BOOL)saveReportExtended:(HTLReportExtendedDto *)reportExtended {
    return [HTLAppContentManger storeReportExtended:reportExtended];
}

@end