//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLActivityListTableViewController.h"
#import "HTLActivityListDataSource.h"
#import "HTLCategoryCell.h"
#import "HTLEditCategoryViewController.h"


@interface HTLActivityListTableViewController () <HTLEditCategoryViewControllerDelegate> {
    HTLActivityListDataSource *dataSource_;
}

@end

@implementation HTLActivityListTableViewController

#pragma mark - HTLEditCategoriesViewController_New

- (HTLActivityListDataSource *)dataSource {
    if (!dataSource_) {
        __weak __typeof(self) weakSelf = self;
        dataSource_ = [HTLActivityListDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf reloadData];
        }];
    }
    return dataSource_;
}

- (void)reloadData {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.destinationViewController isKindOfClass:[HTLEditCategoryViewController class]]) {
        HTLEditCategoryViewController *editCategoryViewController = (HTLEditCategoryViewController *) segue.destinationViewController;
        editCategoryViewController.delegate = self;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        if (indexPath) {
            editCategoryViewController.originalCategory = [self.dataSource customCategoryAtIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataSource.numberOfCustomCategories : self.dataSource.numberOfMandatoryCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategoryCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLCategoryCell defaultIdentifier] forIndexPath:indexPath];
    cell.category = indexPath.section == 0 ? [self.dataSource customCategoryAtIndexPath:indexPath] : [self.dataSource mandatoryCategoryAtIndexPath:indexPath];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Custom" : @"Mandatory";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0) {
        if ([self.dataSource deleteCustomCategoryAtIndexPath:indexPath]) {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }
    }
}

#pragma mark - HTLEditCategoryViewControllerDelegate_New

- (void)editCategoryViewController:(HTLEditCategoryViewController *)viewController finishedWithCategory:(HTLActivity *)category {
    [self.dataSource saveCategory:category];
    [self reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
