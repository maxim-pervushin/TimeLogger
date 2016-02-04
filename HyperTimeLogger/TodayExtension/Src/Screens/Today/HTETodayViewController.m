//
//  HTETodayViewController.m
//  TodayExtension
//
//  Created by Maxim Pervushin on 09/06/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayDataSource.h"
#import "HTETodayViewController.h"
#import "HTLCompletionCollectionViewCell.h"
#import "HTLCompletion.h"
#import "HTLReport+HTLHelpers.h"
#import "HTLReportExtended.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HyperTimeLogger-Swift.h"
#import "NSDate+HTLTimeHelpers.h"


static NSString *const kCompletionCellIdentifier = @"CompletionCell";
// TODO: Load number of completions from defaults
static const NSUInteger kNumberOfCompletions = 9;
static const int kCollectionViewRowHeight = 40;
static const int kCollectionViewMinItemsPerRow = 3;

@interface HTETodayViewController () <NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    HTETodayDataSource *_dataSource;
}

@property(nonatomic, weak) IBOutlet UILabel *lastReportActionTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportCategoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportDurationLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportEndDateLabel;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property(nonatomic, readonly) HTETodayDataSource *dataSource;

- (IBAction)addCustomAction:(id)sender;

- (void)updateUI;

@end

@implementation HTETodayViewController

#pragma mark - HTETodayViewController

- (IBAction)addCustomAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"timelogger://add"] completionHandler:nil];
}

- (void)updateUI {
    HTLReportExtended *reportExtended = self.dataSource.lastReportExtended;
    if (reportExtended) {
        self.lastReportActionTitleLabel.text = reportExtended.action.title;
        self.lastReportCategoryTitleLabel.text = reportExtended.category.title;
        self.lastReportDurationLabel.text = htlStringWithTimeInterval(reportExtended.report.duration);
        self.lastReportEndDateLabel.text = [NSDate stringWithStartDate:reportExtended.report.startDate endDate:reportExtended.report.endDate];
    } else {
        self.lastReportActionTitleLabel.text = @"";
        self.lastReportCategoryTitleLabel.text = @"";
        self.lastReportDurationLabel.text = @"";
        self.lastReportEndDateLabel.text = @"";
    }

    [self.collectionView reloadData];

    self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height;
    [self.view layoutIfNeeded];
}

#pragma mark - UIViewController

- (HTETodayDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTETodayDataSource dataSourceWithDataChangedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateUI];
            });
        }];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.collectionView.collectionViewLayout isKindOfClass:[ZLBalancedFlowLayout class]]) {
        ZLBalancedFlowLayout *balancedFlowLayout = (ZLBalancedFlowLayout *) self.collectionView.collectionViewLayout;
        balancedFlowLayout.minimumLineSpacing = 0;
        balancedFlowLayout.minimumInteritemSpacing = 0;
        balancedFlowLayout.rowHeight = kCollectionViewRowHeight;
        balancedFlowLayout.enforcesRowHeight = YES;
    }
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
    return [self.dataSource completions:kNumberOfCompletions].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
    [cell configureWithCompletion:[self.dataSource completions:kNumberOfCompletions][(NSUInteger) indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / kCollectionViewMinItemsPerRow, kCollectionViewRowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLCompletion *completion = [self.dataSource completions:kNumberOfCompletions][(NSUInteger) indexPath.row];
    [self.dataSource createReportWithCompletion:completion];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end

