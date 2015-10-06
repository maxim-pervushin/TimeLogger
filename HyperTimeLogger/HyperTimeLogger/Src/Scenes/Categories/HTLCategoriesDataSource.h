//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLCategory;


@interface HTLCategoriesDataSource : HTLDataSource

- (NSUInteger)numberOfCategories;

- (HTLCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)deleteCategoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)saveCategory:(HTLCategory *)category;

@end