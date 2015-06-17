//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTLActionDto.h"
#import "HTLCategoryDto.h"
#import "HTLReportDto.h"


@implementation HTLEditReportModelController
@dynamic completions;
@dynamic categories;
@dynamic reportExtended;
@synthesize report = report_;
@synthesize action = action_;
@synthesize category = category_;

#pragma mark - HTLCreateReportModelController

+ (instancetype)modelControllerWithReportExtended:(HTLReportExtendedDto *)reportExtended
                              contentChangedBlock:(HTLModelControllerContentChangedBlock)block {

    HTLEditReportModelController *instance = [self modelControllerWithContentChangedBlock:block];
    if (reportExtended) {
        instance.report = reportExtended.report;
        instance.action = reportExtended.action;
        instance.category = reportExtended.category;
    }
    return instance;
}

- (NSArray *)completions {
    return [[HTLContentManager defaultManager] completionsWithText:self.action.title];
}

- (NSArray *)categories {
    return [HTLContentManager defaultManager].categories;
}

- (HTLReportExtendedDto *)reportExtended {

    HTLActionDto *action = self.action;
    if (!action) {
        action = [HTLActionDto actionWithIdentifier:[NSUUID UUID].UUIDString
                                              title:@""];
    }

    HTLCategoryDto *category = self.category;
    if (!category) {
        category = self.categories.firstObject;
    }

    HTLReportDto *report = self.report;
    if (!report) {
        NSDate *startDate = [HTLContentManager defaultManager].lastReportEndDate;
        report = [HTLReportDto reportWithIdentifier:[NSUUID UUID].UUIDString
                                   actionIdentifier:action.identifier
                                 categoryIdentifier:category.identifier
                                          startDate:startDate ? startDate : [NSDate new]
                                            endDate:[NSDate new]];
    }

    return [HTLReportExtendedDto reportExtendedWithReport:report action:action category:category];
}

- (void)setReport:(HTLReportDto *)report {
    if (![report_ isEqual:report]) {
        report_ = [report copy];
        [self contentChanged];
    }
}

- (void)setAction:(HTLActionDto *)action {
    if (![action_ isEqual:action]) {
        action_ = [action copy];
        [self contentChanged];
    }
}

- (void)setCategory:(HTLCategoryDto *)category {
    if (![category_ isEqual:category]) {
        category_ = [category copy];
        [self contentChanged];
    }
}

- (BOOL)save {
    return [[HTLContentManager defaultManager] storeReportExtended:self.reportExtended];
}

@end