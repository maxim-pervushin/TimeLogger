//
//  HTLReportListViewController.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListViewController.h"
#import "HTLReportExtendedCell.h"
#import "HTLReportListDataSource.h"
#import "HTLReportExtended.h"
#import "HTLDateSectionHeader.h"
#import "HTLAppDelegate.h"
#import "HTLEditReportViewController.h"
#import "HTLStatisticsViewController.h"
#import "NSDate+HTLTimeHelpers.h"
#import "HTLDateSection.h"
#import "HTLEditReportNavigationController.h"
#import "HTLStatisticsNavigationController.h"


static NSString *const kReportCellIdentifier = @"ReportCell";
static NSString *const kDateSectionHeaderIdentifier = @"DateSectionHeader";
static NSString *const kEditReportSegueIdentifier = @"EditReport";
static NSString *const kShowStatisticsSegueIdentifier = @"ShowStatistics";
static const float kAddButtonToBottomDefault = 50.0f;
static const float kHeaderHeight = 35.0f;


@interface HTLReportListViewController () <UITableViewDataSource, UITableViewDelegate, HTLDateSectionHeaderDelegate> {
    HTLReportListDataSource *_dataSource;
    NSTimer *_timer;
}

@property(nonatomic, weak) IBOutlet UIView *addButtonWidget;
@property(nonatomic, weak) IBOutlet UILabel *timerLabel;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToBottomLayoutConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToRightLayoutConstraint;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, readonly) HTLReportListDataSource *dataSource;
@property(nonatomic, assign) CGFloat originalToAddButtonToBottom;
@property(nonatomic, assign) CGFloat originalToAddButtonToRight;

- (IBAction)addButtonPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

- (IBAction)addButtonTapGesture:(UITapGestureRecognizer *)panGestureRecognizer;

- (void)startTimer;

- (void)stopTimer;

- (void)timerAction:(NSTimer *)timer;

- (void)subscribe;

- (void)unsubscribe;

- (void)loadDefaults;

- (void)saveDefaults;

@end

@implementation HTLReportListViewController

#pragma mark - HTLReportListViewController @IB

- (IBAction)addButtonPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalToAddButtonToBottom = self.addButtonToBottomLayoutConstraint.constant;
        self.originalToAddButtonToRight = self.addButtonToRightLayoutConstraint.constant;
    }

    CGPoint translation = [panGestureRecognizer translationInView:self.view];

    CGFloat toBottom = self.originalToAddButtonToBottom - translation.y;
    if (toBottom < 0) {
        toBottom = 0;
    }
    if (toBottom + self.addButtonWidget.frame.size.height > self.view.frame.size.height) {
        toBottom = self.view.frame.size.height - self.addButtonWidget.frame.size.height;
    }

    self.addButtonToBottomLayoutConstraint.constant = toBottom;

    CGFloat toRight = self.originalToAddButtonToRight - translation.x;
    if (toRight < 0) {
        toRight = 0;
    }
    if (toRight + self.addButtonWidget.frame.size.width > self.view.frame.size.width) {
        toRight = self.view.frame.size.width - self.addButtonWidget.frame.size.width;
    }
    self.addButtonToRightLayoutConstraint.constant = toRight;
    [self.view layoutIfNeeded];

    [self saveDefaults];
}

- (IBAction)addButtonTapGesture:(UITapGestureRecognizer *)panGestureRecognizer {
    [self performSegueWithIdentifier:kEditReportSegueIdentifier sender:self];
}

#pragma mark - HTLReportListViewController

- (HTLReportListDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTLReportListDataSource dataSourceWithDataChangedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
    }
    return _dataSource;
}

- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerAction:(NSTimer *)timer {
    NSTimeInterval timeInterval = [[NSDate new] timeIntervalSinceDate:self.dataSource.startDate];
    self.timerLabel.text = htlStringWithTimeInterval(timeInterval);
    if ([UIFont respondsToSelector:@selector(monospacedDigitSystemFontOfSize:weight:)]) {
        self.timerLabel.font = [UIFont monospacedDigitSystemFontOfSize:25 weight:UIFontWeightRegular];
    }
}

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLAppDelegateAddReportURLReceived object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self performSegueWithIdentifier:kEditReportSegueIdentifier sender:self];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTLAppDelegateAddReportURLReceived object:nil];
}

- (void)loadDefaults {
    NSNumber *addButtonToBottomLayoutConstraintNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"self.addButtonToBottomLayoutConstraint.constant"];
    if (addButtonToBottomLayoutConstraintNumber) {
        self.addButtonToBottomLayoutConstraint.constant = addButtonToBottomLayoutConstraintNumber.floatValue;
    } else {
        self.addButtonToBottomLayoutConstraint.constant = kAddButtonToBottomDefault;
    }

    NSNumber *addButtonToRightLayoutConstraintNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"self.addButtonToRightLayoutConstraint.constant"];
    if (addButtonToRightLayoutConstraintNumber) {
        self.addButtonToRightLayoutConstraint.constant = addButtonToRightLayoutConstraintNumber.floatValue;
    } else {
        self.addButtonToRightLayoutConstraint.constant = (self.view.bounds.size.width - self.addButtonWidget.bounds.size.width) / 2;
    }

    [self.view layoutIfNeeded];
}

- (void)saveDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.addButtonToBottomLayoutConstraint.constant) forKey:@"self.addButtonToBottomLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.addButtonToRightLayoutConstraint.constant) forKey:@"self.addButtonToRightLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"DateSectionHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:kDateSectionHeaderIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribe];
    [self.tableView reloadData];

    [self loadDefaults];

    // Scroll to bottom
    NSUInteger sectionsCount = self.dataSource.numberOfReportSections;
    if (sectionsCount > 0) {
        NSUInteger recordsCount = [self.dataSource reportsExtendedForDateSectionAtIndex:sectionsCount - 1].count;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:recordsCount - 1 inSection:sectionsCount - 1]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }

    [self startTimer];

    [self.view bringSubviewToFront:self.addButtonWidget];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
    [self unsubscribe];
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:HTLEditReportNavigationController.class]) {
        HTLEditReportNavigationController *editReportController = segue.destinationViewController;
        HTLReportExtended *reportExtended = nil;
        NSIndexPath *selected = self.tableView.indexPathForSelectedRow;
        if (selected) {
            reportExtended = [self.dataSource reportsExtendedForDateSectionAtIndex:selected.section][(NSUInteger) selected.row];
        }
        editReportController.reportExtended = reportExtended;

    } else if ([segue.destinationViewController isKindOfClass:HTLStatisticsNavigationController.class]) {
        HTLStatisticsNavigationController *statisticsController = segue.destinationViewController;
        if ([sender isKindOfClass:HTLDateSection.class]) {
            statisticsController.dateSection = sender;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.numberOfReportSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfReportsForDateSectionAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HTLDateSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDateSectionHeaderIdentifier];
    [header configureWithDateSection:self.dataSource.reportSections[(NSUInteger) section]];
    header.delegate = self;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLReportExtendedCell *cell = [tableView dequeueReusableCellWithIdentifier:kReportCellIdentifier forIndexPath:indexPath];
    HTLReportExtended *report = [self.dataSource reportsExtendedForDateSectionAtIndex:(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
    [cell configureWithReport:report];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kEditReportSegueIdentifier sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

#pragma mark  - HTLDateSectionHeaderDelegate

- (void)dateSectionHeader:(HTLDateSectionHeader *)dateSectionHeader showStatisticsForDateSection:(HTLDateSection *)dateSection {
    [self performSegueWithIdentifier:kShowStatisticsSegueIdentifier sender:dateSection];
}

@end
