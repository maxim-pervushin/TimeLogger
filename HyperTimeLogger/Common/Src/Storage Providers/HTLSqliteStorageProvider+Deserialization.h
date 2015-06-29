//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLSqliteStorageProvider.h"

@class FMResultSet;
@class HTLActionDto;
@class HTLCompletionDto;
@class HTLReportDto;

@interface HTLSqliteStorageProvider (Deserialization)

- (HTLActionDto *)actionWithResultSet:(FMResultSet *)resultSet;

- (HTLCategoryDto *)categoryWithResultSet:(FMResultSet *)resultSet;

- (HTLDateSectionDto *)dateSectionWithResultSet:(FMResultSet *)resultSet;

- (HTLReportDto *)reportWithResultSet:(FMResultSet *)resultSet;

- (HTLReportExtendedDto *)reportExtendedWithResultSet:(FMResultSet *)resultSet;

- (HTLCompletionDto *)completionWithResultSet:(FMResultSet *)resultSet;

@end