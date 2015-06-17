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
    return [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"identifier"]
                                        title:[resultSet stringForColumn:@"title"]];
}

- (HTLCategoryDto *)categoryWithResultSet:(FMResultSet *)resultSet {
    return [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                            title:[resultSet stringForColumn:@"categoryTitle"]
                                            color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];
}

- (HTLDateSectionDto *)dateSectionWithResultSet:(FMResultSet *)resultSet {
    return [HTLDateSectionDto dateSectionWithDate:[resultSet doubleForColumn:@"endDate"]
                                             time:[resultSet doubleForColumn:@"endTime"]
                                             zone:[resultSet stringForColumn:@"endZone"]];
}

- (HTLReportDto *)reportWithResultSet:(FMResultSet *)resultSet {

    NSDate *startDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"startDate"]
                                        timeInterval:[resultSet doubleForColumn:@"startTime"]
                                                zone:[resultSet stringForColumn:@"startZone"]];

    NSDate *endDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"endDate"]
                                      timeInterval:[resultSet doubleForColumn:@"endTime"]
                                              zone:[resultSet stringForColumn:@"endZone"]];

    return [HTLReportDto reportWithIdentifier:[resultSet stringForColumn:@"identifier"]
                             actionIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                           categoryIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                    startDate:startDate
                                      endDate:endDate];
}

- (HTLReportExtendedDto *)reportExtendedWithResultSet:(FMResultSet *)resultSet {

    NSDate *startDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportStartDate"]
                                        timeInterval:[resultSet doubleForColumn:@"reportStartTime"]
                                                zone:[resultSet stringForColumn:@"reportStartZone"]];

    NSDate *endDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportEndDate"]
                                      timeInterval:[resultSet doubleForColumn:@"reportEndTime"]
                                              zone:[resultSet stringForColumn:@"reportEndZone"]];

    HTLReportDto *report = [HTLReportDto reportWithIdentifier:[resultSet stringForColumn:@"identifier"]
                                             actionIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                           categoryIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                    startDate:startDate
                                                      endDate:endDate];

    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                                        title:[resultSet stringForColumn:@"actionTitle"]];

    HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                                title:[resultSet stringForColumn:@"categoryTitle"]
                                                                color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];


    return [HTLReportExtendedDto reportExtendedWithReport:report action:action category:category];
}

- (HTLCompletionDto *)completionWithResultSet:(FMResultSet *)resultSet {

    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                                        title:[resultSet stringForColumn:@"actionTitle"]];

    HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                                title:[resultSet stringForColumn:@"categoryTitle"]
                                                                color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];

    return [HTLCompletionDto completionWithAction:action
                                         category:category
                                           weight:(NSUInteger) [resultSet intForColumn:@"weight"]];
}

@end