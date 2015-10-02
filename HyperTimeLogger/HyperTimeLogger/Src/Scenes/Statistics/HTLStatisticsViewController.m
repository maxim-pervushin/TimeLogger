//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsViewController.h"
#import "HTLStatisticsDataSource.h"
#import "XYPieChart.h"
#import "HTLCategory.h"
#import "HTLDateSection.h"
#import "HTLPieChartCell.h"
#import "HTLStatisticsItemCell.h"


static NSString *const kPieChartCellIdentifier = @"PieChartCell";
static NSString *const kStatisticsItemCellIdentifier = @"StatisticsItemCell";
static const CGFloat kStatisticsItemCellHeight = 44;


@interface HTLStatisticsViewController () <UITableViewDataSource, UITableViewDelegate, XYPieChartDataSource, XYPieChartDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) HTLStatisticsDataSource *modelController;

- (void)updateUI;

@end


@implementation HTLStatisticsViewController

#pragma mark - HTLStatisticsViewController

- (void)updateUI {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self) weakSelf = self;
    self.modelController = [HTLStatisticsDataSource dataSourceWithDateSection:self.dateSection
                                                          contentChangedBlock:^{
                                                              [weakSelf updateUI];
                                                          }];

    self.title = self.dateSection.fulldateStringLocalized;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.modelController.categories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HTLPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:kPieChartCellIdentifier];
        cell.pieChart.showLabel = NO;
        cell.pieChart.dataSource = self;
        cell.pieChart.delegate = self;
        cell.pieChart.userInteractionEnabled = NO;

        NSUInteger categoriesCount = self.modelController.categories.count;
        if (categoriesCount > 0) {
            [cell.activityIndicator stopAnimating];
        } else {
            [cell.activityIndicator startAnimating];
        }

        return cell;

    } else {
        HTLStatisticsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatisticsItemCellIdentifier];
        HTLCategory *category = self.modelController.categories[(NSUInteger) indexPath.row];
        [cell configureWithStatisticsItem:[self.modelController statisticsForCategory:category]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return tableView.bounds.size.width;
    } else {
        return kStatisticsItemCellHeight;
    }
}

#pragma mark - XYPieChartDataSource, XYPieChartDelegate

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.modelController.categories.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    HTLCategory *category = self.modelController.categories[index];
    HTLStatisticsItemDto *statisticsItem = [self.modelController statisticsForCategory:category];
    return (CGFloat) statisticsItem.totalTime;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    HTLCategory *category = self.modelController.categories[index];
    return category.color;
}

@end

