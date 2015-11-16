//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayViewController.h"
#import "HTLTodayDataSource.h"
#import "HTLReportView.h"
#import "HTLMarkCollectionViewCell.h"
#import "HTLMark.h"
#import "HTLReportEditor.h"
#import "HTLReport.h"
#import "NSDate+HTL.h"
#import "HTLEditReportTableViewController.h"
#import "HyperTimeLogger-Swift.h"

static const int kHeaderHeight = 90;


@interface HTLTodayViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HTLEditReportTableViewControllerDelegate> {
    HTLTodayDataSource *_dataSource;
}

@property(nonatomic, weak) IBOutlet UIView *headerContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property(nonatomic, weak) IBOutlet UIView *centerContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *centerToSuperviewConstraint;
@property(nonatomic, weak) IBOutlet HTLReportView *lastReportView;
@property(nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property(nonatomic, weak) IBOutlet UICollectionView *marksCollectionView;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation HTLTodayViewController

#pragma mark - HTLTodayViewController

- (HTLTodayDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTLTodayDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf updateUIAnimated:YES];
        }];
        [weakSelf updateUIAnimated:NO];
    }
    return _dataSource;
}

- (void)updateUIAnimated:(BOOL)animated {
    if (!self.isViewLoaded) {
        return;
    }

    self.lastReportView.report = self.dataSource.lastReport;
    BOOL headerVisible = self.lastReportView.report != nil;

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view layoutIfNeeded];

        if (headerVisible) {
            weakSelf.centerToSuperviewConstraint.constant = kHeaderHeight;
            weakSelf.headerContainer.hidden = false;
        } else {
            weakSelf.centerToSuperviewConstraint.constant = 0;
            weakSelf.headerContainer.hidden = !headerVisible;
        }

        weakSelf.headerHeightConstraint.constant = kHeaderHeight;

        [UIView animateWithDuration:animated ? 0.5 : 0
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:0.9
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                         }
                         completion:nil];
    });
}

- (void)timerAction:(NSTimer *)timer {
    [self reloadCountdown];
}

- (void)reloadCountdown {
    self.countdownLabel.text = HTLDurationFullString(self.dataSource.currentInterval);
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;

        if ([navigationController.topViewController isKindOfClass:[HTLEditReportTableViewController class]]) {
            HTLEditReportTableViewController *editReportTableViewController = (HTLEditReportTableViewController *) navigationController.topViewController;
            editReportTableViewController.reportEditor.startDate = self.dataSource.lastReportEndDate;
            editReportTableViewController.reportEditor.endDate = [NSDate new];
            editReportTableViewController.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];

    self.marksCollectionView.dataSource = self;
    self.marksCollectionView.delegate = self;
    [self.marksCollectionView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];

    self.marksCollectionView.dataSource = nil;
    self.marksCollectionView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.marksCollectionView.collectionViewLayout isKindOfClass:[HTLTableLayout class]]) {
        HTLTableLayout *layout = (HTLTableLayout *) self.marksCollectionView.collectionViewLayout;
        layout.maxNumberOfColumns = 2;
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.numberOfMarks;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLMark *mark = [self.dataSource markAtIndex:indexPath.row];
    HTLMarkCollectionViewCell *cell = (HTLMarkCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:mark.subtitle.length > 0 ? [HTLMarkCollectionViewCell defaultIdentifierWithSubTitle] : [HTLMarkCollectionViewCell defaultIdentifier] forIndexPath:indexPath];
    cell.mark = mark;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource saveReportWithMarkAtIndex:indexPath.row];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - HTLEditReportTableViewControllerDelegate

- (void)editReportTableViewControllerDidCancel:(HTLEditReportTableViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editReportTableViewController:(HTLEditReportTableViewController *)viewController didFinishEditingWithReport:(HTLReport *)report {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.dataSource saveReport:report];
}

@end
