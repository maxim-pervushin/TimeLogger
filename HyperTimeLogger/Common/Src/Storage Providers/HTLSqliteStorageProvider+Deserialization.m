//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"
#import "HTLDateSection.h"
#import "NSDate+HTLComponents.h"
#import "HTLCompletion.h"
#import "HexColor.h"
#import "FMDB.h"
#import "HTLReportExtended.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLSqliteStorageProvider+Deserialization.h"


@implementation HTLSqliteStorageProvider (Deserialization)

- (HTLAction *)unpackAction:(FMResultSet *)resultSet {
    return [HTLAction actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                     title:[resultSet stringForColumn:@"actionTitle"]];
}

- (HTLCategory *)unpackCategory:(FMResultSet *)resultSet {
    return [HTLCategory categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                         title:[resultSet stringForColumn:@"categoryTitle"]
                                         color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];
}

- (HTLDateSection *)unpackDateSection:(FMResultSet *)resultSet {
    return [HTLDateSection dateSectionWithDateString:[resultSet stringForColumn:@"endDate"]
                                          timeString:[resultSet stringForColumn:@"endTime"]
                                            timeZone:[resultSet stringForColumn:@"endZone"]];
}

- (HTLReport *)unpackReport:(FMResultSet *)resultSet {

    NSDate *startDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"reportStartDate"]
                                        timeString:[resultSet stringForColumn:@"reportStartTime"]
                                    timeZoneString:[resultSet stringForColumn:@"reportStartZone"]];

    NSDate *endDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"reportEndDate"]
                                      timeString:[resultSet stringForColumn:@"reportEndTime"]
                                  timeZoneString:[resultSet stringForColumn:@"reportEndZone"]];

    return [HTLReport reportWithIdentifier:[resultSet stringForColumn:@"identifier"]
                          actionIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                        categoryIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                 startDate:startDate
                                   endDate:endDate];
}

- (HTLReportExtended *)unpackReportExtended:(FMResultSet *)resultSet {
    return [HTLReportExtended reportExtendedWithReport:[self unpackReport:resultSet]
                                                action:[self unpackAction:resultSet]
                                              category:[self unpackCategory:resultSet]];
}

- (HTLCompletion *)unpackCompletion:(FMResultSet *)resultSet {
    return [HTLCompletion completionWithAction:[self unpackAction:resultSet]
                                      category:[self unpackCategory:resultSet]
                                        weight:(NSUInteger) [resultSet intForColumn:@"weight"]];
}

@end