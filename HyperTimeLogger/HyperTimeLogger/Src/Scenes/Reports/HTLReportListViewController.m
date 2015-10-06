//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListViewController.h"
#import "HTLReportListDataSource.h"
#import "HTLDateSection.h"
#import "HTLReportCell.h"
#import "HTLReportDateListViewController.h"


@interface HTLReportListViewController () <HTLReportDateListViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UIBarButtonItem *previousDateSectionButton;
@property(nonatomic, weak) IBOutlet UIButton *currentDateSectionButton;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *nextDateSectionButton;

@property(nonatomic, strong) HTLReportListDataSource *dataSource;

@end

@implementation HTLReportListViewController

#pragma mark - HTLReportListViewController_New @IB

- (IBAction)previousDateSectionButtonAction:(id)sender {
    [self.dataSource decrementCurrentDateSectionIndex];
}

- (IBAction)nextDateSectionButtonAction:(id)sender {
    [self.dataSource incrementCurrentDateSectionIndex];
}

#pragma mark - HTLReportListViewController_New

- (void)reloadData {
    self.previousDateSectionButton.enabled = self.dataSource.hasPreviousDateSection;
    self.nextDateSectionButton.enabled = self.dataSource.hasNextDateSection;

    [self.currentDateSectionButton setTitle:self.dataSource.selectedDateSection.fulldateStringLocalized forState:UIControlStateNormal];

    self.title = self.dataSource.selectedDateSection.fulldateStringLocalized;

    [self.tableView reloadData];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfReports;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLReportCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLReportCell defaultIdentifier] forIndexPath:indexPath];
    cell.report = [self.dataSource reportAtIndexPath:indexPath];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // TODO: Use custom view
    UILabel *header = (id) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!header) {
        header = [UILabel new];
        header.text = @"TEST";
        header.backgroundColor = [UIColor greenColor];
    }

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
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
    __weak __typeof(self) weakSelf = self;
    self.dataSource = [HTLReportListDataSource dataSourceWithContentChangedBlock:^{
        [weakSelf reloadData];
    }];
    [self reloadData];
}

#pragma mark - HTLReportDateListViewControllerDelegate_New

- (void)reportDateListViewController:(HTLReportDateListViewController *)viewController didSelectedDateSection:(HTLDateSection *)dateSection {
    self.dataSource.selectedDateSection = dateSection;
    [self.navigationController popViewControllerAnimated:YES];
}

@end