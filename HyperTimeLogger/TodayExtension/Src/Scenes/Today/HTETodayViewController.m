//
//  HTETodayViewController.m
//  TodayExtension
//
//  Created by Maxim Pervushin on 09/06/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayDataSource.h"
#import "HTETodayViewController.h"
#import "HTLMarkCollectionViewCell.h"
#import "HTLReport+Helpers.h"
#import "HTLReportView.h"
#import "HyperTimeLogger-Swift.h"
#import <NotificationCenter/NotificationCenter.h>

@interface HTETodayViewController () <NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate> {
    HTETodayDataSource *_dataSource;
    NSLayoutConstraint *_collectionViewHeightConstraint;
}

@property(nonatomic, weak) IBOutlet HTLReportView *lastReportView;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)customMarkButtonAction:(id)sender;

- (void)updateUI;

@end

@implementation HTETodayViewController

#pragma mark - HTETodayViewController

- (HTETodayDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTETodayDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf updateUI];
        }];
        [weakSelf updateUI];
    }
    return _dataSource;
}

- (NSLayoutConstraint *)collectionViewHeightConstraint {
    if (!_collectionViewHeightConstraint && self.isViewLoaded) {
        _collectionViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:self.collectionView.contentSize.height];
        [self.collectionView addConstraint:_collectionViewHeightConstraint];
    }
    return _collectionViewHeightConstraint;
}

- (IBAction)customMarkButtonAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"timelogger://add"] completionHandler:nil];
}

- (void)updateUI {
    self.lastReportView.report = self.dataSource.lastReport;
    [self.collectionView reloadData];
    [self collectionViewHeightConstraint].constant = self.collectionView.contentSize.height;
    [self.view layoutIfNeeded];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self updateUI];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDataSource

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

@end

