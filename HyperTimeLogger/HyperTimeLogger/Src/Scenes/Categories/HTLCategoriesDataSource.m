//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoriesDataSource.h"
#import "HTLCategory.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"


@implementation HTLCategoriesDataSource

- (NSUInteger)numberOfCategories {
    return [HTLAppContentManger numberOfCategoriesWithDateSection:nil];
}

- (HTLCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLAppContentManger categoriesWithDateSection:nil][(NSUInteger) indexPath.row];
}

- (BOOL)deleteCategoryAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)saveCategory:(HTLCategory *)category {
    return [HTLAppContentManger saveCategory:category];
}

@end