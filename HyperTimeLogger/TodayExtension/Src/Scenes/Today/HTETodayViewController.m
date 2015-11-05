//
//  HTETodayViewController.m
//  TodayExtension
//
//  Created by Maxim Pervushin on 09/06/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayDataSource.h"
#import "HTETodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HyperTimeLogger-Swift.h"
#import "HTLReport.h"

static NSString *const kCompletionCellIdentifier = @"CompletionCell";
// TODO: Load number of completions from defaults
static const NSUInteger kNumberOfCompletions = 9;
static const int kCollectionViewRowHeight = 40;
static const int kCollectionViewMinItemsPerRow = 3;

@interface HTETodayViewController () <NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) IBOutlet UILabel *lastReportActionTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportCategoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportDurationLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastReportEndDateLabel;

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property(nonatomic, strong) HTETodayDataSource *dataSource;

- (IBAction)addCustomAction:(id)sender;

- (void)updateUI;

@end

@implementation HTETodayViewController

#pragma mark - HTETodayViewController

- (IBAction)addCustomAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"timelogger://add"] completionHandler:nil];
}

- (void)updateUI {
    HTLReport *lastReport = self.dataSource.lastReport;
    if (lastReport) {
//        self.lastReportActionTitleLabel.text = lastReport.action.title;
//        self.lastReportCategoryTitleLabel.text = lastReport.mark.title;
//        self.lastReportDurationLabel.text = lastReport.report.durationString;
//        self.lastReportEndDateLabel.text = lastReport.report.endDateString;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [HTETodayDataSource dataSourceWithContentChangedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    }];

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
//    return [self.dataSource completions:kNumberOfCompletions].count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
//    [cell configureWithCompletion:[self.dataSource completions:kNumberOfCompletions][(NSUInteger) indexPath.row]];
//    return cell;
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / kCollectionViewMinItemsPerRow, kCollectionViewRowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    HTLCompletion *completion = [self.dataSource completions:kNumberOfCompletions][(NSUInteger) indexPath.row];
//    [self.dataSource createReportWithCompletion:completion];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end

