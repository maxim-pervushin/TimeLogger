//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Parse/Parse.h>
#import "HTLParseStorageProvider.h"
#import "HTLMark.h"
#import "HexColor.h"
#import "HTLReport.h"
#import "NSDate+HTLComponents.h"
#import "HTLDateSection.h"


@implementation HTLParseStorageProvider {
    NSDate *_launchDate;
}

+ (instancetype)parseStorageProviderWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    return [[self alloc] initWithApplicationId:applicationId clientKey:clientKey];
}

- (instancetype)initWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    self = [super init];
    if (self) {
        [Parse setApplicationId:applicationId clientKey:clientKey];
        _launchDate = [NSDate new];
    }
    return self;
}

#pragma mark - Pack / Unpack

- (PFObject *)packMark:(HTLMark *)mark {
    if (!mark) {
        return nil;
    }

    PFObject *object = [PFObject objectWithClassName:kMarkParseClassName];
    object[@"title"] = mark.title.length > 0 ? mark.title : @"";
    object[@"subtitle"] = mark.subtitle.length > 0 ? mark.subtitle : @"";
    object[@"color"] = mark.color != nil ? [UIColor hexStringFromRGBColor:mark.color] : [UIColor hexStringFromRGBColor:[UIColor blackColor]];
    return object;
}

- (HTLMark *)unpackMark:(PFObject *)object {
    return [HTLMark markWithTitle:object[@"title"] subTitle:object[@"subtitle"] color:[UIColor colorWithHexString:object[@"color"]]];
}

- (PFObject *)packReport:(HTLReport *)report {
    NSString *startDateString;
    NSString *startTimeString;
    NSString *startTimeZoneString;
    [report.startDate getDateString:&startDateString timeString:&startTimeString timeZoneString:&startTimeZoneString];

    NSString *endDateString;
    NSString *endTimeString;
    NSString *endTimeZoneString;
    [report.endDate getDateString:&endDateString timeString:&endTimeString timeZoneString:&endTimeZoneString];

    PFObject *object = [PFObject objectWithClassName:kReportParseClassName];
    object[@"identifier"] = report.identifier.length > 0 ? report.identifier : @"";
    object[@"title"] = report.mark.title.length > 0 ? report.mark.title : @"";
    object[@"subtitle"] = report.mark.subtitle.length > 0 ? report.mark.subtitle : @"";
    object[@"color"] = report.mark.color != nil ? [UIColor hexStringFromRGBColor:report.mark.color] : [UIColor hexStringFromRGBColor:[UIColor blackColor]];
    object[@"startDate"] = startDateString;
    object[@"startTime"] = startTimeString;
    object[@"startTimeZone"] = startTimeZoneString;
    object[@"endDate"] = endDateString;
    object[@"endTime"] = endTimeString;
    object[@"endTimeZone"] = endTimeZoneString;
    return object;
}

- (HTLReport *)unpackReport:(PFObject *)object {
    NSDate *startDate = [NSDate dateWithDateString:object[@"startDate"]
                                        timeString:object[@"startTime"]
                                    timeZoneString:object[@"startTimeZone"]];

    NSDate *endDate = [NSDate dateWithDateString:object[@"endDate"]
                                      timeString:object[@"endTime"]
                                  timeZoneString:object[@"endTimeZone"]];

    HTLMark *mark = [self unpackMark:object];

    return [HTLReport reportWithIdentifier:object[@"identifier"] mark:mark startDate:startDate endDate:endDate];
}

#pragma mark - HTLStorageProvider

- (BOOL)clear {
    return NO;
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
    PFQuery *query = [PFQuery queryWithClassName:kMarkParseClassName];
    NSArray *objects = [query findObjects];
    NSMutableArray *result = [NSMutableArray new];
    for (PFObject *object in objects) {
        HTLMark *mark = [self unpackMark:object];
        if (mark) {
            [result addObject:mark];
        }

    }
    return [result copy];
}

- (BOOL)saveMark:(HTLMark *)mark {
    // TODO: Check if mark exists
    PFObject *object = [self packMark:mark];
    if (object) {
        return [object save];
    }
    return NO;
}

- (BOOL)deleteMark:(HTLMark *)mark {
    return NO;
}

- (NSUInteger)numberOfDateSections {
    return 0;
}

- (NSArray *)dateSections {
    return nil;
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self reportsWithDateSection:dateSection mark:nil].count;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    PFQuery *query = [PFQuery queryWithClassName:kReportParseClassName];
    if (dateSection) {
        [query whereKey:@"endDate" equalTo:dateSection.dateString];
    }
    if (mark) {
//        [query whereKey:@"endDate" equalTo:dateSection.dateString];
    }

    NSArray *objects = [query findObjects];
    NSMutableArray *result = [NSMutableArray new];
    for (PFObject *object in objects) {
        HTLReport *report = [self unpackReport:object];
        if (report) {
            [result addObject:report];
        }
    }
    return [result copy];
}

- (BOOL)saveReport:(HTLReport *)report {
    if (!report || !report.mark) {
        return NO;
    }
    if (![[self mandatoryMarks] containsObject:report.mark]) {
        [self saveMark:report.mark];
    }

    PFObject *object = [self packReport:report];
    if (object) {
        return [object save];
    }
    return NO;

//    _reportsById[report.identifier] = report;
//    [self store];
//    return YES;
}

- (NSDate *)lastReportEndDate {
    if ([self lastReport] && [self lastReport].endDate) {
        return [self lastReport].endDate;
    }
    return _launchDate;
}

- (HTLReport *)lastReport {
    PFQuery *query = [PFQuery queryWithClassName:kReportParseClassName];
    [query orderByDescending:@"endDate"];
    [query addDescendingOrder:@"endTime"];
    PFObject *object = [query getFirstObject];
    return [self unpackReport:object];
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    return nil;
}


@end