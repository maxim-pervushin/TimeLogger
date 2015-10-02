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


static NSString *const kReportCellIdentifier = @"ReportCell";
static NSString *const kDateSectionHeaderIdentifier = @"DateSectionHeader";
static NSString *const kCreateReportSegueIdentifier = @"CreateReport";
static NSString *const kShowStatisticsSegueIdentifier = @"ShowStatistics";
static const float kAddButtonToBottomDefault = 50.0f;
static const float kHeaderHeight = 35.0f;


@interface HTLReportListViewController () <UITableViewDataSource, UITableViewDelegate, HTLDateSectionHeaderDelegate>

@property(nonatomic, weak) IBOutlet UIButton *addButton;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToBottomLayoutConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToRightLayoutConstraint;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) HTLReportListDataSource *dataSource;
@property(nonatomic, assign) CGFloat originalToAddButtonToBottom;
@property(nonatomic, assign) CGFloat originalToAddButtonToRight;

- (IBAction)addButtonPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

- (void)subscribe;

- (void)unsubscribe;

- (void)loadDefaults;

- (void)saveDefaults;

@end

@implementation HTLReportListViewController

#pragma mark - HTLReportListViewController

- (IBAction)addButtonPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalToAddButtonToBottom = self.addButtonToBottomLayoutConstraint.constant;
        self.originalToAddButtonToRight = self.addButtonToRightLayoutConstraint.constant;
    }

    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    self.addButtonToBottomLayoutConstraint.constant = self.originalToAddButtonToBottom - translation.y;
    self.addButtonToRightLayoutConstraint.constant = self.originalToAddButtonToRight - translation.x;
    [self.view layoutIfNeeded];

    [self saveDefaults];
}

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLAppDelegateAddReportURLReceived object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self performSegueWithIdentifier:kCreateReportSegueIdentifier sender:self];
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
        self.addButtonToRightLayoutConstraint.constant = (self.view.bounds.size.width - self.addButton.bounds.size.width) / 2;
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

    __weak __typeof(self) weakSelf = self;
    self.dataSource = [HTLReportListDataSource dataSourceWithContentChangedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribe];
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditReport"] && [segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        HTLEditReportViewController *createReportViewController = (HTLEditReportViewController *) navigationController.topViewController;

        NSIndexPath *selected = self.tableView.indexPathForSelectedRow;
        if (!selected) {
            return;
        }

        HTLReportExtended *reportExtended = [self.dataSource reportsExtendedForDateSectionAtIndex:selected.section][(NSUInteger) selected.row];
        if (!reportExtended) {
            return;
        }

        createReportViewController.reportExtended = reportExtended;

    } else if ([segue.identifier isEqualToString:kShowStatisticsSegueIdentifier]) {
        HTLStatisticsViewController *statisticsViewController = segue.destinationViewController;
        statisticsViewController.dateSection = sender;
    }
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
