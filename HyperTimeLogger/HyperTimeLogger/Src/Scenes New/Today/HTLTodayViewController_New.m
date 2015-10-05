//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayViewController_New.h"
#import "HTLTodayDataSource_New.h"
#import "HTLCategoryCell_New.h"


@interface HTLTodayViewController_New ()

@property(nonatomic, strong) HTLTodayDataSource_New *dataSource;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation HTLTodayViewController_New

#pragma mark - HTLTodayViewController_New

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
    HTLCategoryCell_New *cell = (HTLCategoryCell_New *) [tableView dequeueReusableCellWithIdentifier:[HTLCategoryCell_New defaultIdentifier] forIndexPath:indexPath];
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
    __weak __typeof(self) weakSelf = self;
    self.dataSource = [HTLTodayDataSource_New dataSourceWithContentChangedBlock:^{
        [weakSelf reloadData];
    }];
    [self reloadTitle];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
}

@end