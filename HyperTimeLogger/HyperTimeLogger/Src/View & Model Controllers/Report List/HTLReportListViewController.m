//
//  HTLReportListViewController.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListViewController.h"
#import "HTLReportExtendedCell.h"
#import "HTLReportListModelController.h"
#import "HTLReportExtendedDto.h"
#import "HTLDateSectionHeader.h"
#import "HTLAppDelegate.h"
#import "HTLEditReportViewController.h"
#import "HTLStatisticsViewController.h"

static NSString *const kReportCellIdentifier = @"ReportCell";
static NSString *const kDateSectionHeaderIdentifier = @"DateSectionHeader";
static const float kAddButtonToBottomDefault = 50.0f;

static NSString *const kCreateReportSegueIdentifier = @"CreateReport";

static NSString *const kShowStatisticsSegueIdentifier = @"ShowStatistics";

@interface HTLReportListViewController () <UITableViewDataSource, UITableViewDelegate, HTLDateSectionHeaderDelegate>

@property(nonatomic, weak) IBOutlet UIButton *addButton;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToBottomLayoutConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonToRightLayoutConstraint;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) HTLReportListModelController *modelController;
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
    self.modelController = [HTLReportListModelController modelControllerWithContentChangedBlock:^{
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
    NSUInteger sectionsCount = self.modelController.reportSections.count;
    if (sectionsCount > 0) {
        NSUInteger recordsCount = [self.modelController reportsExtendedForDateSectionAtIndex:sectionsCount - 1].count;
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

        HTLReportExtendedDto *reportExtended = [self.modelController reportsExtendedForDateSectionAtIndex:selected.section][(NSUInteger) selected.row];
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
    return self.modelController.reportSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelController reportsExtendedForDateSectionAtIndex:section].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HTLDateSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDateSectionHeaderIdentifier];
    [header configureWithDateSection:self.modelController.reportSections[(NSUInteger) section]];
    header.delegate = self;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLReportExtendedCell *cell = [tableView dequeueReusableCellWithIdentifier:kReportCellIdentifier forIndexPath:indexPath];
    HTLReportExtendedDto *report = [self.modelController reportsExtendedForDateSectionAtIndex:(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
    [cell configureWithReport:report];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}

#pragma mark  - HTLDateSectionHeaderDelegate

- (void)dateSectionHeader:(HTLDateSectionHeader *)dateSectionHeader showStatisticsForDateSection:(HTLDateSectionDto *)dateSection {
    [self performSegueWithIdentifier:kShowStatisticsSegueIdentifier sender:dateSection];
}

@end
