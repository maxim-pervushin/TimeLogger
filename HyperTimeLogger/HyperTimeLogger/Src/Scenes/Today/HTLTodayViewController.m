//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayViewController.h"
#import "HTLTodayDataSource.h"
#import "HTLCategoryCell.h"


@interface HTLTodayViewController ()

@property(nonatomic, strong, readonly) HTLTodayDataSource *dataSource;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation HTLTodayViewController
@synthesize dataSource = dataSource_;

#pragma mark - HTLTodayViewController_New

- (HTLTodayDataSource *)dataSource {
    if (!dataSource_) {
        __weak __typeof(self) weakSelf = self;
        dataSource_ = [HTLTodayDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf reloadData];
        }];
    }
    return dataSource_;
}

// TODO: Move this method somewhere
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                                      (long) hours, (long) minutes, (long) seconds];
}

- (void)reloadTitle {
    self.title = [self stringFromTimeInterval:self.dataSource.currentInterval];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)timerAction:(NSTimer *)timer {
    [self reloadTitle];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataSource.numberOfCustomCategories : self.dataSource.numberOfMandatoryCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategoryCell *cell = (HTLCategoryCell *) [tableView dequeueReusableCellWithIdentifier:[HTLCategoryCell defaultIdentifier] forIndexPath:indexPath];
    cell.category = indexPath.section == 0 ? [self.dataSource customCategoryAtIndex:indexPath.row] : [self.dataSource mandatoryCategoryAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.dataSource saveReportWithCustomCategoryAtIndex:indexPath.row];
    } else {
        [self.dataSource saveReportWithMandatoryCategoryAtIndex:indexPath.row];
    }
    [self reloadTitle];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadTitle];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
}

@end