//
// Created by Maxim Pervushin on 18/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsModelController+TestData.h"
#import "HTLCategoryDto.h"
#import "NSDate+HTLComponents.h"
#import "HTLReportDto.h"
#import "HTLReportExtendedDto.h"
#import "HTLContentManager.h"

@implementation HTLSettingsModelController (TestData)

- (NSString *)newIdentifier {
    return [NSUUID UUID].UUIDString;
}

- (NSDate *)yesterdayHours:(NSInteger)hours minutes:(NSInteger)minutes {
    NSDate *yesterday = [[NSDate new] dateByAddingTimeInterval:-86400.0];

    NSString *dateString;
    NSString *timeString;
    NSString *timeZoneString;
    [yesterday getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];

    NSDate *yesterdayStart = [NSDate dateWithDateString:dateString timeString:@"00:00:00" timeZoneString:timeZoneString];

    return [yesterdayStart dateByAddingTimeInterval:hours * 3600 + minutes * 60];
}

- (BOOL)generateTestData {
    DDLogDebug(@"Generating test data...");

    NSArray *testDataSets = @[

            // Day before yesterday
            @{@"from" : @(-2400 + 28), @"to" : @(-2400 + 727), @"action" : @"Проснулся", @"category" : @"Sleep"},
            @{@"from" : @(-2400 + 727), @"to" : @(-2400 + 734), @"action" : @"Умылся", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 734), @"to" : @(-2400 + 750), @"action" : @"Приготовил завтрак", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 750), @"to" : @(-2400 + 805), @"action" : @"Позавтракал", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 805), @"to" : @(-2400 + 817), @"action" : @"Убрался", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 817), @"to" : @(-2400 + 824), @"action" : @"Почистил зубы", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 824), @"to" : @(-2400 + 840), @"action" : @"Собрался", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 840), @"to" : @(-2400 + 857), @"action" : @"Пришел в офис", @"category" : @"Road"},
            @{@"from" : @(-2400 + 857), @"to" : @(-2400 + 926), @"action" : @"Биды на апворк", @"category" : @"Improvement"},
            @{@"from" : @(-2400 + 926), @"to" : @(-2400 + 1001), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 1001), @"to" : @(-2400 + 1040), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1040), @"to" : @(-2400 + 1113), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 1113), @"to" : @(-2400 + 1125), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1125), @"to" : @(-2400 + 1135), @"action" : @"Пришел на обед", @"category" : @"Road"},
            @{@"from" : @(-2400 + 1135), @"to" : @(-2400 + 1315), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1315), @"to" : @(-2400 + 1328), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 1328), @"to" : @(-2400 + 1408), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1408), @"to" : @(-2400 + 1415), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 1415), @"to" : @(-2400 + 1514), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1514), @"to" : @(-2400 + 1529), @"action" : @"Перекусил", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 1529), @"to" : @(-2400 + 1550), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(-2400 + 1550), @"to" : @(-2400 + 1605), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 1605), @"to" : @(-2400 + 1638), @"action" : @"Пришел домой", @"category" : @"Road"},
            @{@"from" : @(-2400 + 1638), @"to" : @(-2400 + 1638), @"action" : @"Собрался на тренировку", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 1638), @"to" : @(-2400 + 1650), @"action" : @"Пришел на тренировку", @"category" : @"Road"},
            @{@"from" : @(-2400 + 1650), @"to" : @(-2400 + 1654), @"action" : @"Переоделся", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 1654), @"to" : @(-2400 + 1818), @"action" : @"Потренировался", @"category" : @"Improvement"},
            @{@"from" : @(-2400 + 1818), @"to" : @(-2400 + 1833), @"action" : @"Вымылся", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 1833), @"to" : @(-2400 + 1855), @"action" : @"Пришел домой", @"category" : @"Road"},
            @{@"from" : @(-2400 + 1855), @"to" : @(-2400 + 2020), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 2020), @"to" : @(-2400 + 2045), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(-2400 + 2045), @"to" : @(-2400 + 2116), @"action" : @"Приготовил ужин", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 2116), @"to" : @(-2400 + 2213), @"action" : @"Поужинал", @"category" : @"Personal"},
            @{@"from" : @(-2400 + 2213), @"to" : @(-2400 + 2359), @"action" : @"Интернет", @"category" : @"Time Waste"},

            // Yesterday
            @{@"from" : @(28), @"to" : @(727), @"action" : @"Проснулся", @"category" : @"Sleep"},
            @{@"from" : @(727), @"to" : @(734), @"action" : @"Умылся", @"category" : @"Personal"},
            @{@"from" : @(734), @"to" : @(750), @"action" : @"Приготовил завтрак", @"category" : @"Personal"},
            @{@"from" : @(750), @"to" : @(805), @"action" : @"Позавтракал", @"category" : @"Personal"},
            @{@"from" : @(805), @"to" : @(817), @"action" : @"Убрался", @"category" : @"Personal"},
            @{@"from" : @(817), @"to" : @(824), @"action" : @"Почистил зубы", @"category" : @"Personal"},
            @{@"from" : @(824), @"to" : @(840), @"action" : @"Собрался", @"category" : @"Personal"},
            @{@"from" : @(840), @"to" : @(857), @"action" : @"Пришел в офис", @"category" : @"Road"},
            @{@"from" : @(857), @"to" : @(926), @"action" : @"Биды на апворк", @"category" : @"Improvement"},
            @{@"from" : @(926), @"to" : @(1001), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(1001), @"to" : @(1040), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1040), @"to" : @(1113), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(1113), @"to" : @(1125), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1125), @"to" : @(1135), @"action" : @"Пришел на обед", @"category" : @"Road"},
            @{@"from" : @(1135), @"to" : @(1315), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1315), @"to" : @(1328), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(1328), @"to" : @(1408), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1408), @"to" : @(1415), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(1415), @"to" : @(1514), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1514), @"to" : @(1529), @"action" : @"Перекусил", @"category" : @"Personal"},
            @{@"from" : @(1529), @"to" : @(1550), @"action" : @"Time Logger", @"category" : @"Work"},
            @{@"from" : @(1550), @"to" : @(1605), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(1605), @"to" : @(1638), @"action" : @"Пришел домой", @"category" : @"Road"},
            @{@"from" : @(1638), @"to" : @(1638), @"action" : @"Собрался на тренировку", @"category" : @"Personal"},
            @{@"from" : @(1638), @"to" : @(1650), @"action" : @"Пришел на тренировку", @"category" : @"Road"},
            @{@"from" : @(1650), @"to" : @(1654), @"action" : @"Переоделся", @"category" : @"Personal"},
            @{@"from" : @(1654), @"to" : @(1818), @"action" : @"Потренировался", @"category" : @"Improvement"},
            @{@"from" : @(1818), @"to" : @(1833), @"action" : @"Вымылся", @"category" : @"Personal"},
            @{@"from" : @(1833), @"to" : @(1855), @"action" : @"Пришел домой", @"category" : @"Road"},
            @{@"from" : @(1855), @"to" : @(2020), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(2020), @"to" : @(2045), @"action" : @"Интернет", @"category" : @"Time Waste"},
            @{@"from" : @(2045), @"to" : @(2116), @"action" : @"Приготовил ужин", @"category" : @"Personal"},
            @{@"from" : @(2116), @"to" : @(2213), @"action" : @"Поужинал", @"category" : @"Personal"},
            @{@"from" : @(2213), @"to" : @(2359), @"action" : @"Интернет", @"category" : @"Time Waste"},
    ];

    for (NSDictionary *testDataSet in testDataSets) {
        HTLActionDto *action = [HTLActionDto actionWithIdentifier:[self newIdentifier] title:testDataSet[@"action"]];
        HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:[self newIdentifier] title:testDataSet[@"category"] color:[UIColor redColor]];

        NSInteger from = ((NSNumber *) testDataSet[@"from"]).integerValue;
        NSInteger fromHours = from / 100;
        NSInteger fromMinutes = from - fromHours * 100;
        NSDate *startDate = [self yesterdayHours:fromHours minutes:fromMinutes];

        NSInteger to = ((NSNumber *) testDataSet[@"to"]).integerValue;
        NSInteger toHours = to / 100;
        NSInteger toMinutes = to - toHours * 100;
        NSDate *endDate = [self yesterdayHours:toHours minutes:toMinutes];

        DDLogDebug(@"\nstart: %@\nend: %@", startDate, endDate);

        HTLReportDto *report = [HTLReportDto reportWithIdentifier:[self newIdentifier]
                                                 actionIdentifier:action.identifier
                                               categoryIdentifier:category.identifier
                                                        startDate:startDate
                                                          endDate:endDate];

        [[HTLContentManager defaultManager] storeReportExtended:
                [HTLReportExtendedDto reportExtendedWithReport:report
                                                        action:action
                                                      category:category]];

    }


    DDLogDebug(@"Test data generated...");
    return YES;
}

@end