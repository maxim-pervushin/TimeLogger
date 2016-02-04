//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLSqliteStorageProvider.h"

@class FMResultSet;
@class HTLAction;
@class HTLCompletion;
@class HTLReport;

@interface HTLSqliteStorageProvider (Deserialization)

- (HTLAction *)actionWithResultSet:(FMResultSet *)resultSet;

- (HTLCategory *)categoryWithResultSet:(FMResultSet *)resultSet;

- (HTLDateSection *)dateSectionWithResultSet:(FMResultSet *)resultSet;

- (HTLReport *)reportWithResultSet:(FMResultSet *)resultSet;

- (HTLReportExtended *)reportExtendedWithResultSet:(FMResultSet *)resultSet;

- (HTLCompletion *)completionWithResultSet:(FMResultSet *)resultSet;

@end