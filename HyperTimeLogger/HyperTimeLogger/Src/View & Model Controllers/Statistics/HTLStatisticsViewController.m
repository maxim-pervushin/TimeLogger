//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsViewController.h"
#import "HTLStatisticsDataSource.h"
#import "XYPieChart.h"
#import "HTLCategoryDto.h"
#import "HTLDateSectionDto.h"
#import "HTLPieChartCell.h"
#import "HTLStatisticsItemCell.h"
#import "HyperTimeLogger-Swift.h"


static NSString *const kPieChartCellIdentifier = @"PieChartCell";
static NSString *const kStatisticsItemCellIdentifier = @"StatisticsItemCell";
static const CGFloat kStatisticsItemCellHeight = 44;


@interface HTLStatisticsViewController () <UITableViewDataSource, UITableViewDelegate, XYPieChartDataSource, XYPieChartDelegate> {
    HTLStatisticsDataSource *_dataSource;
}

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, readonly) HTLStatisticsDataSource *dataSource;

- (IBAction)doneButtonAction:(id)sender;

- (void)updateUI;

@end


@implementation HTLStatisticsViewController

#pragma mark - HTLStatisticsViewController @IB

- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTLStatisticsViewController

- (HTLStatisticsDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTLStatisticsDataSource dataSourceWithDateSection:self.dateSection
                                                        dataChangedBlock:^{
                                                            [weakSelf updateUI];
                                                        }];
    }
    return _dataSource;
}

- (void)updateUI {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dateSection.fulldateStringLocalized;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.loaded && self.dataSource.totalTime == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.loaded && self.dataSource.totalTime == 0) {
        return 1;
    } else {
        if (section == 0) {
            return 1;
        } else {
            return self.dataSource.categories.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.loaded && self.dataSource.totalTime == 0) {
        return [tableView dequeueReusableCellWithIdentifier:HTLNoContentCell.defaultIdentifier forIndexPath:indexPath];
    } else {
        if (indexPath.section == 0) {
            HTLPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:kPieChartCellIdentifier];
            cell.pieChart.showLabel = NO;
            cell.pieChart.dataSource = self;
            cell.pieChart.delegate = self;
            cell.pieChart.userInteractionEnabled = NO;

            NSUInteger categoriesCount = self.dataSource.categories.count;
            if (categoriesCount > 0) {
                [cell.activityIndicator stopAnimating];
            } else {
                [cell.activityIndicator startAnimating];
            }

            return cell;

        } else {
            HTLStatisticsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatisticsItemCellIdentifier];
            HTLCategoryDto *category = self.dataSource.categories[(NSUInteger) indexPath.row];
            NSTimeInterval totalTime = self.dataSource.totalTime;
            [cell configureWithStatisticsItem:[self.dataSource statisticsForCategory:category] totalTime:totalTime];
            return cell;
        }
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
    return self.dataSource.categories.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    HTLCategoryDto *category = self.dataSource.categories[index];
    HTLStatisticsItemDto *statisticsItem = [self.dataSource statisticsForCategory:category];
    return (CGFloat) statisticsItem.totalTime;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    HTLCategoryDto *category = self.dataSource.categories[index];
    return category.color;
}

@end

