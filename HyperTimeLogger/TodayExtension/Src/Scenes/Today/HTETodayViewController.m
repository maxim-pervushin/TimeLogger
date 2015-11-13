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
#import "HTLReport.h"
#import "HTLReportView.h"
#import "HyperTimeLogger-Swift.h"
#import "NSDate+HTL.h"
#import <NotificationCenter/NotificationCenter.h>

static NSString *const kCompletionCellIdentifier = @"CompletionCell";
// TODO: Load number of completions from defaults
static const NSUInteger kNumberOfCompletions = 9;
static const int kCollectionViewRowHeight = 40;
static const int kCollectionViewMinItemsPerRow = 3;

@interface HTETodayViewController () <NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) IBOutlet HTLReportView *lastReportView;


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
    self.lastReportView.report = self.dataSource.lastReport;
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

    if ([self.collectionView.collectionViewLayout isKindOfClass:[HTLTableLayout class]]) {
        HTLTableLayout *layout = (HTLTableLayout *) self.collectionView.collectionViewLayout;
        layout.numberOfColumns = 3;
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

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

