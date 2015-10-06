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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategoryCell *cell = (HTLCategoryCell *) [tableView dequeueReusableCellWithIdentifier:[HTLCategoryCell defaultIdentifier] forIndexPath:indexPath];
    cell.category = [self.dataSource categoryAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource saveReportWithCategoryAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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