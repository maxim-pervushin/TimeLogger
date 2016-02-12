//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMarkListTableViewController.h"
#import "HTLMarkListDataSource.h"
#import "HTLMarkCollectionViewCell.h"
#import "HTLEditCategoryViewController.h"
#import "HTLMark.h"


@interface HTLMarkListTableViewController () <HTLEditCategoryViewControllerDelegate> {
    HTLMarkListDataSource *dataSource_;
}

@end

@implementation HTLMarkListTableViewController

#pragma mark - HTLMarkListTableViewController

- (HTLMarkListDataSource *)dataSource {
    if (!dataSource_) {
        __weak __typeof(self) weakSelf = self;
        dataSource_ = [HTLMarkListDataSource dataSourceWithContentChangedBlock:^{
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
            editCategoryViewController.originalCategory = [self.dataSource customMarkAtIndexPath:indexPath];
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
    HTLMark *mark = indexPath.section == 0 ? [self.dataSource customMarkAtIndexPath:indexPath] : [self.dataSource mandatoryMarkAtIndexPath:indexPath];
    HTLMarkTableViewCell *cell;
    if (mark.subtitle.length > 0) {
        cell = (HTLMarkTableViewCell *) [tableView dequeueReusableCellWithIdentifier:[HTLMarkTableViewCell defaultIdentifierWithSubTitle] forIndexPath:indexPath];
    } else {
        cell = (HTLMarkTableViewCell *) [tableView dequeueReusableCellWithIdentifier:[HTLMarkTableViewCell defaultIdentifier] forIndexPath:indexPath];
    }
    cell.mark = mark;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Custom" : @"Mandatory";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLMark *mark = indexPath.section == 0 ? [self.dataSource customMarkAtIndexPath:indexPath] : [self.dataSource mandatoryMarkAtIndexPath:indexPath];
    if (mark.subtitle.length > 0) {
        return 55.0;
    } else {
        return 44.0;
    }
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

- (void)editCategoryViewController:(HTLEditCategoryViewController *)viewController finishedWithCategory:(HTLMark *)category {
    [self.dataSource saveCategory:category];
    [self reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
