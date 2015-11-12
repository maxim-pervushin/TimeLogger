//
// Created by Maxim Pervushin on 30/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMemoryStorageProvider.h"
#import "HTLMark.h"
#import "HTLReport.h"
#import "HTLDateSection.h"
#import "NSDate+HTLComponents.h"
#import "HTLStatisticsItem.h"

@interface HTLMemoryStorageProvider () {
    NSMutableSet *_marks;
    NSMutableDictionary *_reportsById;
    NSDate *_launchDate;
    NSCache *_cache;
}

@end


@implementation HTLMemoryStorageProvider

#pragma mark - NSObject

- (NSDate *)yesterdayHours:(NSInteger)hours minutes:(NSInteger)minutes {
    NSDate *yesterday = [[NSDate new] dateByAddingTimeInterval:-86400.0];

    NSString *dateString;
    NSString *timeString;
    NSString *timeZoneString;
    [yesterday getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];

    NSDate *yesterdayStart = [NSDate dateWithDateString:dateString timeString:@"00:00:00" timeZoneString:timeZoneString];

    return [yesterdayStart dateByAddingTimeInterval:hours * 3600 + minutes * 60];
}

- (void)generateTestData {
    NSString *languageCode = [NSLocale componentsFromLocaleIdentifier:[NSLocale currentLocale].localeIdentifier][@"kCFLocaleLanguageCodeKey"];
    if (![languageCode isEqualToString:@"ru"]) {
        languageCode = @"en";
    }
    NSString *fileName = [NSString stringWithFormat:@"testdata_%@", languageCode];
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    NSArray *testData = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];

//    DDLogDebug(@"%@", testData);

    NSArray *allMarks = [self.mandatoryMarks arrayByAddingObjectsFromArray:self.customMarks];

    int repeats = 33;
    for (int i = 1; i <= repeats; i++) {
        for (NSDictionary *testDataSet in testData) {
            NSInteger from = ((NSNumber *) testDataSet[@"from"]).integerValue;
            NSInteger fromHours = from / 100;
            NSInteger fromMinutes = from - fromHours * 100;
            NSDate *startDate = [self yesterdayHours:fromHours - 24 * (i - 1) minutes:fromMinutes];

            NSInteger to = ((NSNumber *) testDataSet[@"to"]).integerValue;
            NSInteger toHours = to / 100;
            NSInteger toMinutes = to - toHours * 100;
            NSDate *endDate = [self yesterdayHours:toHours - 24 * (i - 1) minutes:toMinutes];

            HTLMark *mark = allMarks[arc4random() % allMarks.count];
            HTLReport *report = [HTLReport reportWithMark:mark startDate:startDate endDate:endDate];
            _reportsById[report.identifier] = report;
        }
    }
    [self changed];
}

- (void)initializeTestData {
    // Custom categories
    [self saveMark:[HTLMark markWithTitle:@"Work" subTitle:@"logger" color:[UIColor paperColorLightGreen400]]];
    [self saveMark:[HTLMark markWithTitle:@"Improvement" subTitle:@"english" color:[UIColor paperColorDeepOrange300]]];
    [self saveMark:[HTLMark markWithTitle:@"Improvement" subTitle:@"algorithms" color:[UIColor paperColorDeepOrange400]]];
}

- (void)changed {
    [self.changesObserver changed:self];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _marks = [NSMutableSet new];
        _reportsById = [NSMutableDictionary new];
        _launchDate = [NSDate new];
        _cache = [NSCache new];
        [self initializeTestData];
    }
    return self;
}

#pragma mark - HTLStorageProvider

- (BOOL)clear {
    [_marks removeAllObjects];
    [_reportsById removeAllObjects];
    return YES;
}

- (NSArray *)mandatoryMarks {
    return @[
            [HTLMark markWithTitle:@"Sleep" subTitle:@"" color:[UIColor paperColorDeepPurple]],
            [HTLMark markWithTitle:@"Personal" subTitle:@"" color:[UIColor paperColorIndigo]],
            [HTLMark markWithTitle:@"Road" subTitle:@"" color:[UIColor paperColorRed]],
            [HTLMark markWithTitle:@"Work" subTitle:@"" color:[UIColor paperColorLightGreen]],
            [HTLMark markWithTitle:@"Improvement" subTitle:@"" color:[UIColor paperColorDeepOrange]],
            [HTLMark markWithTitle:@"Recreation" subTitle:@"" color:[UIColor paperColorCyan]],
            [HTLMark markWithTitle:@"Time Waste" subTitle:@"" color:[UIColor paperColorBrown]]
    ];
}

- (NSArray *)customMarks {
    return [_marks sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
}

- (BOOL)saveMark:(HTLMark *)mark {
    [_marks addObject:mark];
    [self changed];
    return YES;
}

- (BOOL)deleteMark:(HTLMark *)mark {
    if (![_marks containsObject:mark]) {
        return NO;
    }
    [_marks removeObject:mark];
    [self changed];
    return YES;
}

- (NSUInteger)numberOfDateSections {
    return [self dateSections].count;
}

- (NSArray *)dateSections {
    NSMutableSet *dateSections = [NSMutableSet new];
    for (HTLReport *report in _reportsById.allValues) {
        NSString *dateString;
        NSString *timeString;
        NSString *timeZoneString;
        [report.endDate getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];
        [dateSections addObject:[HTLDateSection dateSectionWithDateString:dateString timeString:@"" timeZone:@""]];
    }

    return [dateSections sortedArrayUsingDescriptors:@[]];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self reportsWithDateSection:dateSection mark:nil].count;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @"",
                                                    mark ? @(mark.hash) : @""];
    NSArray *cached = [_cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Reports Extended");
        return cached;
    }

    DDLogDebug(@"reportsWithDateSection:");

    NSArray *filtered = [_reportsById.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HTLReport *report, NSDictionary *bindings) {
        if (mark && ![mark isEqual:report.mark]) {
            return NO;
        }

        if (dateSection) {
            NSString *dateString;
            NSString *timeString;
            NSString *timeZoneString;
            [report.endDate getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];
            if (![dateString isEqual:dateSection.dateString]) {
                return NO;
            }
        }

        return YES;
    }]];

    NSArray *sorted = [filtered sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]]];

    [_cache setObject:sorted forKey:cacheKey];

    return sorted;
}

- (BOOL)saveReport:(HTLReport *)report {
    if (!report || !report.mark) {
        return NO;
    }
    if (![[self mandatoryMarks] containsObject:report.mark]) {
        [_marks addObject:report.mark];
    }
    _reportsById[report.identifier] = report;
    [self changed];
    return YES;
}

- (NSDate *)lastReportEndDate {
    HTLReport *lastReport = [self lastReport];
    if (lastReport) {
        return lastReport.endDate;
    }
    return _launchDate;
}

- (HTLReport *)lastReport {
    return [[_reportsById.allValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]]] lastObject];
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    NSMutableArray *statistics = [NSMutableArray new];
    for (HTLMark *activity in self.mandatoryMarks) {
        [statistics addObject:
                [HTLStatisticsItem statisticsItemWithMark:activity totalTime:arc4random() % 72000 totalReports:arc4random() % 12]];
    }
    for (HTLMark *activity in self.customMarks) {
        [statistics addObject:
                [HTLStatisticsItem statisticsItemWithMark:activity totalTime:arc4random() % 72000 totalReports:arc4random() % 12]];
    }
    return [statistics copy];
}

@end