//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListViewController_New.h"
#import "HTLReportListDataSource_New.h"
#import "HTLDateSection.h"
#import "HTLReportCell_New.h"


@interface HTLReportListViewController_New ()

@property(nonatomic, weak) IBOutlet UIBarButtonItem *previousDateSectionButton;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *nextDateSectionButton;

@property(nonatomic, strong) HTLReportListDataSource_New *dataSource;

@end

@implementation HTLReportListViewController_New

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

    self.title = self.dataSource.currentDateSection.fulldateStringLocalized;

    [self.tableView reloadData];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfReports;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLReportCell_New *cell = (id) [tableView dequeueReusableCellWithIdentifier:[HTLReportCell_New defaultIdentifier] forIndexPath:indexPath];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self) weakSelf = self;
    self.dataSource = [HTLReportListDataSource_New dataSourceWithContentChangedBlock:^{
        [weakSelf reloadData];
    }];
    [self reloadData];
}

@end