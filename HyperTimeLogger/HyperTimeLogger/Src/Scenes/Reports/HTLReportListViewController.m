//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListViewController.h"
#import "HTLReportListDataSource.h"
#import "HTLDateSection.h"
#import "HTLReportTableViewCell.h"
#import "HTLReportDateListViewController.h"
#import "HTLStatisticsHeader.h"
#import "HTLReport.h"


@interface HTLReportListViewController () <HTLReportDateListViewControllerDelegate> {
    HTLReportListDataSource *_dataSource;
}

@property(nonatomic, weak) IBOutlet UIBarButtonItem *previousDateSectionButton;
@property(nonatomic, weak) IBOutlet UIButton *currentDateSectionButton;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *nextDateSectionButton;

@property(nonatomic, readonly) HTLReportListDataSource *dataSource;

@end

@implementation HTLReportListViewController
@dynamic dataSource;

#pragma mark - HTLReportListViewController_New @IB

- (IBAction)previousDateSectionButtonAction:(id)sender {
    [self.dataSource decrementCurrentDateSectionIndex];
}

- (IBAction)nextDateSectionButtonAction:(id)sender {
    [self.dataSource incrementCurrentDateSectionIndex];
}

#pragma mark - HTLReportListViewController_New

- (HTLReportListDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTLReportListDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf updateUI];
        }];

    }
    return _dataSource;
}

- (void)updateUI {
    if (!self.isViewLoaded) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.previousDateSectionButton.enabled = weakSelf.dataSource.hasPreviousDateSection;
        weakSelf.nextDateSectionButton.enabled = weakSelf.dataSource.hasNextDateSection;

        [weakSelf.currentDateSectionButton setTitle:weakSelf.dataSource.selectedDateSection.fulldateStringLocalized forState:UIControlStateNormal];

        weakSelf.title = weakSelf.dataSource.selectedDateSection.fulldateStringLocalized;

        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfReports;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLReport *report = [self.dataSource reportAtIndexPath:indexPath];
    HTLReportTableViewCell *cell;
    if (report.mark.subtitle.length > 0) {
        cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLReportTableViewCell defaultIdentifierWithSubtitle] forIndexPath:indexPath];
    } else {
        cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLReportTableViewCell defaultIdentifier] forIndexPath:indexPath];
    }
    cell.report = report;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HTLStatisticsHeader *header = (id) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    header.statistics = self.dataSource.statistics;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.destinationViewController isKindOfClass:[HTLReportDateListViewController class]]) {
        HTLReportDateListViewController *reportDateListViewController = (HTLReportDateListViewController *) segue.destinationViewController;
        reportDateListViewController.selectedDateSection = self.dataSource.selectedDateSection;
        reportDateListViewController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HTLStatisticsHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"Header"];

//    __weak __typeof(self) weakSelf = self;
//    self.dataSource = [HTLReportListDataSource dataSourceWithContentChangedBlock:^{
//        [weakSelf updateUI];
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
    [self.dataSource reloadStatistics];
}

#pragma mark - HTLReportDateListViewControllerDelegate_New

- (void)reportDateListViewController:(HTLReportDateListViewController *)viewController didSelectedDateSection:(HTLDateSection *)dateSection {
    self.dataSource.selectedDateSection = dateSection;
    [self.navigationController popViewControllerAnimated:YES];
}

@end