//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLActivity;


@interface HTLActivityListDataSource : HTLDataSource

- (NSUInteger)numberOfMandatoryCategories;

- (NSUInteger)numberOfCustomCategories;

- (HTLActivity *)mandatoryCategoryAtIndexPath:(NSIndexPath *)indexPath;

- (HTLActivity *)customCategoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)deleteCustomCategoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)saveCategory:(HTLActivity *)category;

@end