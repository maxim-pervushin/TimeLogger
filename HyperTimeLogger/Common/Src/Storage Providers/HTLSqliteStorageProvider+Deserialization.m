//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"
#import "HTLDateSection.h"
#import "NSDate+HTLComponents.h"
#import "HexColor.h"
#import "FMDB.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLSqliteStorageProvider+Deserialization.h"


@implementation HTLSqliteStorageProvider (Deserialization)

- (HTLCategory *)unpackCategory:(FMResultSet *)resultSet {
    return [HTLCategory categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                         title:[resultSet stringForColumn:@"categoryTitle"]
                                      subTitle:[resultSet stringForColumn:@"categorySubTitle"]
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

    HTLCategory *category = [HTLCategory categoryWithIdentifier:[resultSet stringForColumn:@"reportCategoryIdentifier"]
                                                          title:[resultSet stringForColumn:@"reportCategoryTitle"]
                                                       subTitle:[resultSet stringForColumn:@"reportCategorySubTitle"]
                                                          color:[UIColor colorWithHexString:[resultSet stringForColumn:@"reportCategoryColor"]]];

    return [HTLReport reportWithCategory:category startDate:startDate endDate:endDate];
}

@end