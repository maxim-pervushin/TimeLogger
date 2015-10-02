//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtended.h"
#import "HTLAction.h"
#import "HTLCategory.h"
#import "HTLReport.h"
#import "HTLAppDelegate.h"


@implementation HTLEditReportModelController
@dynamic completions;
@dynamic categories;
@dynamic reportExtended;
@synthesize report = report_;
@synthesize action = action_;
@synthesize category = category_;

#pragma mark - HTLCreateReportModelController

+ (instancetype)modelControllerWithReportExtended:(HTLReportExtended *)reportExtended
                              contentChangedBlock:(HTLDataSourceChangedBlock)block {

    HTLEditReportModelController *instance = [self dataSourceWithContentChangedBlock:block];
    if (reportExtended) {
        instance.report = reportExtended.report;
        instance.action = reportExtended.action;
        instance.category = reportExtended.category;
    }
    return instance;
}

- (NSArray *)completions {
    return [HTLAppContentManger completionsWithText:self.action.title];
}

- (NSArray *)categories {
    return [HTLAppContentManger categoriesWithDateSection:nil];
}

- (HTLReportExtended *)reportExtended {

    HTLAction *action = self.action;
    if (!action) {
        action = [HTLAction actionWithIdentifier:[NSUUID UUID].UUIDString
                                           title:@""];
    }

    HTLCategory *category = self.category;
    if (!category) {
        category = self.categories.firstObject;
    }

    HTLReport *report = self.report;
    if (!report) {
        NSDate *startDate = HTLAppContentManger.lastReportEndDate;
        report = [HTLReport reportWithIdentifier:[NSUUID UUID].UUIDString
                                actionIdentifier:action.identifier
                              categoryIdentifier:category.identifier
                                       startDate:startDate ? startDate : [NSDate new]
                                         endDate:[NSDate new]];
    }

    return [HTLReportExtended reportExtendedWithReport:report action:action category:category];
}

- (void)setReport:(HTLReport *)report {
    if (![report_ isEqual:report]) {
        report_ = [report copy];
        [self contentChanged];
    }
}

- (void)setAction:(HTLAction *)action {
    if (![action_ isEqual:action]) {
        action_ = [action copy];
        [self contentChanged];
    }
}

- (void)setCategory:(HTLCategory *)category {
    if (![category_ isEqual:category]) {
        category_ = [category copy];
        [self contentChanged];
    }
}

- (BOOL)save {
    return [HTLAppContentManger saveReportExtended:self.reportExtended];
}

@end