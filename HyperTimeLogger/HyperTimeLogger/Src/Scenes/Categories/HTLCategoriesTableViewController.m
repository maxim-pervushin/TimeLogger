//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoriesTableViewController.h"
#import "HTLCategoriesDataSource.h"
#import "HTLCategoryCell.h"
#import "HTLEditCategoryViewController.h"


@interface HTLCategoriesTableViewController () <HTLEditCategoryViewControllerDelegate>

@property(nonatomic, readonly) HTLCategoriesDataSource *dataSource;

@end

@implementation HTLCategoriesTableViewController
@synthesize dataSource = dataSource_;

#pragma mark - HTLEditCategoriesViewController_New

- (HTLCategoriesDataSource *)dataSource {
    if (!dataSource_) {
        __weak __typeof(self) weakSelf = self;
        dataSource_ = [HTLCategoriesDataSource dataSourceWithContentChangedBlock:^{
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
            editCategoryViewController.originalCategory = [self.dataSource categoryAtIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategoryCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLCategoryCell defaultIdentifier] forIndexPath:indexPath];
    cell.category = [self.dataSource categoryAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.dataSource deleteCategoryAtIndexPath:indexPath]) {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            //[self reloadData];
        }
    }
}

#pragma mark - HTLEditCategoryViewControllerDelegate_New

- (void)editCategoryViewController:(HTLEditCategoryViewController *)viewController finishedWithCategory:(HTLCategory *)category {
    [self.dataSource saveCategory:category];
    [self reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
