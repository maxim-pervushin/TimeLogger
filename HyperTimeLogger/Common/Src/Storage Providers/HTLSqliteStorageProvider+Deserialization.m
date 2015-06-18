//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDto.h"
#import "HTLDateSectionDto.h"
#import "NSDate+HTLComponents.h"
#import "HTLCompletionDto.h"
#import "HexColor.h"
#import "FMDB.h"
#import "HTLReportExtendedDto.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLSqliteStorageProvider+Deserialization.h"


@implementation HTLSqliteStorageProvider (Deserialization)

- (HTLActionDto *)actionWithResultSet:(FMResultSet *)resultSet {
    return [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                        title:[resultSet stringForColumn:@"actionTitle"]];
}

- (HTLCategoryDto *)categoryWithResultSet:(FMResultSet *)resultSet {
    return [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                            title:[resultSet stringForColumn:@"categoryTitle"]
                                            color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];
}

- (HTLDateSectionDto *)dateSectionWithResultSet:(FMResultSet *)resultSet {
    return [HTLDateSectionDto dateSectionWithDateString:[resultSet stringForColumn:@"endDate"]
                                             timeString:[resultSet stringForColumn:@"endTime"]
                                               timeZone:[resultSet stringForColumn:@"endZone"]];
}

- (HTLReportDto *)reportWithResultSet:(FMResultSet *)resultSet {

    NSDate *startDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"reportStartDate"]
                                        timeString:[resultSet stringForColumn:@"reportStartTime"]
                                    timeZoneString:[resultSet stringForColumn:@"reportStartZone"]];

    NSDate *endDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"reportEndDate"]
                                      timeString:[resultSet stringForColumn:@"reportEndTime"]
                                  timeZoneString:[resultSet stringForColumn:@"reportEndZone"]];

    return [HTLReportDto reportWithIdentifier:[resultSet stringForColumn:@"identifier"]
                             actionIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                           categoryIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                    startDate:startDate
                                      endDate:endDate];
}

- (HTLReportExtendedDto *)reportExtendedWithResultSet:(FMResultSet *)resultSet {
    return [HTLReportExtendedDto reportExtendedWithReport:[self reportWithResultSet:resultSet]
                                                   action:[self actionWithResultSet:resultSet]
                                                 category:[self categoryWithResultSet:resultSet]];
}

- (HTLCompletionDto *)completionWithResultSet:(FMResultSet *)resultSet {
    return [HTLCompletionDto completionWithAction:[self actionWithResultSet:resultSet]
                                         category:[self categoryWithResultSet:resultSet]
                                           weight:(NSUInteger) [resultSet intForColumn:@"weight"]];
}

@end