//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayViewController_New.h"
#import "HTLToday_NewDataSource.h"
#import "HTLActivity.h"
#import "HTLActivityCell.h"
#import "HyperTimeLogger-Swift.h"


@interface HTLTodayViewController_New () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    HTLToday_NewDataSource *dataSource_;
}

@property(nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation HTLTodayViewController_New

#pragma mark - HTLTodayViewController_New

- (HTLToday_NewDataSource *)dataSource {
    if (!dataSource_) {
        [self reloadData];
    }
    return dataSource_;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                                      (long) hours, (long) minutes, (long) seconds];
}

- (void)reloadCountdown {
    self.countdownLabel.text = [self stringFromTimeInterval:self.dataSource.currentInterval];
}

- (void)reloadData {
    if (!self.isViewLoaded) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
        [weakSelf reloadCountdown];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timerAction:(id)timer {
    [self reloadCountdown];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadCountdown];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.numberOfActivities;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLActivity *activity = [self.dataSource activityAtIndex:indexPath.row];
    HTLActivityCell *cell;
    if (activity.subTitle.length == 0) {
        cell = (id) [collectionView dequeueReusableCellWithReuseIdentifier:[HTLActivityCell defaultIdentifier] forIndexPath:indexPath];
    } else {
        cell = (id) [collectionView dequeueReusableCellWithReuseIdentifier:[HTLActivityCell defaultIdentifierWithSubTitle] forIndexPath:indexPath];
    }
    cell.activity = activity;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource saveReportWithActivityAtIndex:indexPath.row];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end


