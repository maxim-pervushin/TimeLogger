//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsDataSource.h"
#import "HTLAppDelegate.h"
#import "HTLCategory.h"
#import "NSDate+HTLComponents.h"
#import "HTLReport+Helpers.h"


@implementation HTLSettingsDataSource

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
//    DDLogDebug(@"Generating test data...");
//
//    NSString *languageCode = [NSLocale componentsFromLocaleIdentifier:[NSLocale currentLocale].localeIdentifier][@"kCFLocaleLanguageCodeKey"];
//    if (![languageCode isEqualToString:@"ru"]) {
//        languageCode = @"en";
//    }
//    NSString *fileName = [NSString stringWithFormat:@"testdata_%@", languageCode];
//    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
//    NSArray *testData = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
//
////    int repeats = 100; // ~3 month of data
//    int repeats = 33;
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//
//        for (int i = 1; i <= repeats; i++) {
//            DDLogDebug(@"%.1f%%", (double) i / (double) repeats * 100);
//
//            for (NSDictionary *testDataSet in testData) {
//                HTLAction *action = [HTLAction actionWithIdentifier:[self newIdentifier] title:testDataSet[@"action"]];
//                HTLCategory *category = [HTLCategory categoryWithIdentifier:[self newIdentifier] title:testDataSet[@"categoryTitle"] subTitle:testDataSet[@"categorySubTitle"] color:[UIColor redColor]];
//
//                NSInteger from = ((NSNumber *) testDataSet[@"from"]).integerValue;
//                NSInteger fromHours = from / 100;
//                NSInteger fromMinutes = from - fromHours * 100;
//                NSDate *startDate = [self yesterdayHours:fromHours - 24 * (i - 1) minutes:fromMinutes];
//
//                NSInteger to = ((NSNumber *) testDataSet[@"to"]).integerValue;
//                NSInteger toHours = to / 100;
//                NSInteger toMinutes = to - toHours * 100;
//                NSDate *endDate = [self yesterdayHours:toHours - 24 * (i - 1) minutes:toMinutes];
//
//
//                HTLReport *report = [HTLReport reportWithCategory:[self newIdentifier] startDate:startDate endDate:endDate];
//
//                [HTLAppContentManger saveReport:
//                        [HTLReportExtended reportExtendedWithReport:report
//                                                             action:action
//                                                           category:category]];
//
//            }
//        }
//
//        DDLogDebug(@"Test data generated...");
//    });
//
//    return YES;
    return NO;
}


@end