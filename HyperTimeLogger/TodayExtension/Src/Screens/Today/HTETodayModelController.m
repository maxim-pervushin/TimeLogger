//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayModelController.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTLCompletionDto.h"
#import "HTLCategoryDto.h"
#import "HTLActionDto.h"
#import "HTLReportDto.h"


@interface HTETodayModelController ()

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTETodayModelController

#pragma mark - HTETodayModelController

- (NSArray *)completions:(NSUInteger)numberOfCompletions {
    NSArray *completions = [[HTLContentManager defaultManager] findCompletionsWithText:nil];
    NSMutableArray *result = [NSMutableArray new];
    for (NSUInteger i = 0; i < completions.count && i < numberOfCompletions; i++) {
        [result addObject:completions[i]];
    }
    return [result copy];
}

- (BOOL)createReportWithCompletion:(HTLCompletionDto *)completion {
    NSDate *startDate = [HTLContentManager defaultManager].findLastReportEndDate;
    HTLReportDto *report = [HTLReportDto reportWithIdentifier:[NSUUID UUID].UUIDString
                                             actionIdentifier:completion.action.identifier
                                           categoryIdentifier:completion.category.identifier
                                                    startDate:startDate ? startDate : [NSDate new]
                                                      endDate:[NSDate new]];
    HTLReportExtendedDto *reportExtended =
            [HTLReportExtendedDto reportExtendedWithReport:report action:completion.action category:completion.category];

    return [[HTLContentManager defaultManager] storeReportExtended:reportExtended];
}

- (HTLReportExtendedDto *)lastReportExtended {
    return [HTLContentManager defaultManager].findLastReportExtended;
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf contentChanged];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTLStorageProviderChangedNotification object:nil];
};

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        [self subscribe];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end