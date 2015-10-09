//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLActivityListDataSource.h"
#import "HTLActivity.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"


@implementation HTLActivityListDataSource

- (NSUInteger)numberOfMandatoryCategories {
    return HTLAppContentManger.mandatoryCategories.count;
}

- (NSUInteger)numberOfCustomCategories {
    return HTLAppContentManger.customCategories.count;
}

- (HTLActivity *)mandatoryCategoryAtIndexPath:(NSIndexPath *)indexPath {
    return HTLAppContentManger.mandatoryCategories[(NSUInteger) indexPath.row];
}

- (HTLActivity *)customCategoryAtIndexPath:(NSIndexPath *)indexPath {
    return HTLAppContentManger.customCategories[(NSUInteger) indexPath.row];
}

- (BOOL)deleteCustomCategoryAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLAppContentManger deleteCategory:[self customCategoryAtIndexPath:indexPath]];
}

- (BOOL)saveCategory:(HTLActivity *)category {
    return [HTLAppContentManger saveCategory:category];
}

@end