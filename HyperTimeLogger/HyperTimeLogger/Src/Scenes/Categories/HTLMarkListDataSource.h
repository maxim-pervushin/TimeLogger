//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLMark;


@interface HTLMarkListDataSource : HTLDataSource

- (NSUInteger)numberOfMandatoryCategories;

- (NSUInteger)numberOfCustomCategories;

- (HTLMark *)mandatoryMarkAtIndexPath:(NSIndexPath *)indexPath;

- (HTLMark *)customMarkAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)deleteCustomCategoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)saveCategory:(HTLMark *)category;

@end