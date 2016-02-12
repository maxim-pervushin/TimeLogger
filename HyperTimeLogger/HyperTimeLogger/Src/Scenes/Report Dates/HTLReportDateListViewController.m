//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDateListViewController.h"
#import "HTLReportDateListDataSource.h"
#import "HTLDateSectionCell.h"
#import "HTLDateSection.h"

@interface HTLReportDateListViewController ()

@property(nonatomic, strong, readonly) HTLReportDateListDataSource *dataSource;

@end

@implementation HTLReportDateListViewController
@synthesize dataSource = dataSource_;

#pragma mark - HTLReportDateListViewController_New

- (HTLReportDateListDataSource *)dataSource {
    if (!dataSource_) {
        __weak __typeof(self) weakSelf = self;
        dataSource_ = [HTLReportDateListDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf reloadData];
        }];
    }
    return dataSource_;
}

- (HTLDateSection *)selectedDateSection {
    return self.dataSource.selectedDateSection;
}

- (void)setSelectedDateSection:(HTLDateSection *)selectedDateSection {
    self.dataSource.selectedDateSection = selectedDateSection;
}

- (void)reloadData {
    if (!self.isViewLoaded) {
        return;
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfDateSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLDateSectionCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLDateSectionCell defaultIdentifier] forIndexPath:indexPath];
    HTLDateSection *dateSection = [self.dataSource dateSectionAtIndexPath:indexPath];
    cell.dateSection = dateSection;
    if ([dateSection isEqual:self.dataSource.selectedDateSection]) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.dataSource.selectedDateSection = [self.dataSource dateSectionAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.delegate reportDateListViewController:self didSelectedDateSection:self.dataSource.selectedDateSection];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

@end
