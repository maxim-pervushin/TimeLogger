//
//  HTETodayViewController.m
//  TodayExtension
//
//  Created by Maxim Pervushin on 09/06/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayModelController.h"
#import "HTETodayViewController.h"
#import "HTLCompletionCollectionViewCell.h"
#import "HTLCompletionDto.h"
#import "HTLReportDto+Helpers.h"
#import "HTLReportExtendedDto.h"
#import <NotificationCenter/NotificationCenter.h>
#import <ZLBalancedFlowLayout/ZLBalancedFlowLayout-Swift.h>

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

@property(nonatomic, strong) HTETodayModelController *modelController;

- (IBAction)addCustomAction:(id)sender;

- (void)updateUI;

@end

@implementation HTETodayViewController

#pragma mark - HTETodayViewController

- (IBAction)addCustomAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"timelogger://add"] completionHandler:nil];
}

- (void)updateUI {
    HTLReportExtendedDto *reportExtended = self.modelController.lastReportExtended;
    if (reportExtended) {
        self.lastReportActionTitleLabel.text = reportExtended.action.title;
        self.lastReportCategoryTitleLabel.text = reportExtended.category.title;
        self.lastReportDurationLabel.text = reportExtended.report.durationString;
        self.lastReportEndDateLabel.text = reportExtended.report.endDateString;
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

    self.modelController = [HTETodayModelController modelControllerWithContentChangedBlock:^{
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
    return [self.modelController completions:kNumberOfCompletions].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
    [cell configureWithCompletion:[self.modelController completions:kNumberOfCompletions][(NSUInteger) indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / kCollectionViewMinItemsPerRow, kCollectionViewRowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLCompletionDto *completion = [self.modelController completions:kNumberOfCompletions][(NSUInteger) indexPath.row];
    [self.modelController createReportWithCompletion:completion];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end

