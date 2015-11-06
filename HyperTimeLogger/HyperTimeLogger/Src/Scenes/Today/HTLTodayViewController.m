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
#import "HTLColorPickerTableView.h"
#import "HTLReport.h"
#import "HTLMarkEditor.h"
#import "NSDate+HTL.h"
#import "HTLEditReportTableViewController.h"


static const int kHeaderHeight = 90;
static const int kTopContainerHeight = 140;


@interface HTLTodayViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HTLEditReportTableViewControllerDelegate> {
    BOOL _editorVisible;
    HTLTodayDataSource *_dataSource;
    HTLReportEditor *_reportEditor;
}

@property(nonatomic, weak) IBOutlet UIView *dimView;

@property(nonatomic, weak) IBOutlet UIView *headerContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *headerHeightConstraint;

@property(nonatomic, weak) IBOutlet UIView *topContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property(nonatomic, weak) IBOutlet UIView *centerContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *centerToSuperviewConstraint;

@property(nonatomic, weak) IBOutlet UIView *bottomContainer;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *topToCenterConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *centerToBottomConstraint;


@property(nonatomic, weak) IBOutlet HTLReportView *lastReportView;
@property(nonatomic, weak) IBOutlet UILabel *customReportDatesLabel;
@property(nonatomic, weak) IBOutlet UILabel *customReportDurationLabel;
@property(nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property(nonatomic, weak) IBOutlet UICollectionView *marksCollectionView;

@property(nonatomic, weak) IBOutlet UIButton *saveButton;
@property(nonatomic, weak) IBOutlet UITextField *titleTextView;
@property(nonatomic, weak) IBOutlet UITextField *subTitleTextView;
@property(nonatomic, weak) IBOutlet HTLColorPickerTableView *colorPickerView;


@property(assign) BOOL editorVisible;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, readonly) HTLReportEditor *reportEditor;

@end

@implementation HTLTodayViewController
@dynamic editorVisible;
@dynamic reportEditor;

#pragma mark - HTLTodayViewController_New @IB

- (IBAction)cancelButtonAction:(id)sender {
    self.editorVisible = NO;
    [self.titleTextView resignFirstResponder];
    [self.subTitleTextView resignFirstResponder];
}

- (IBAction)saveButtonAction:(id)sender {
    if ([self.dataSource saveReport:self.reportEditor.report]) {
        self.editorVisible = NO;
        [self.titleTextView resignFirstResponder];
        [self.subTitleTextView resignFirstResponder];
    }
}

//- (IBAction)customMarkButtonAction:(id)sender {
//    self.reportEditor.startDate = self.dataSource.lastReportEndDate;
//    self.reportEditor.endDate = [NSDate new];
//    self.editorVisible = YES;
//    [self.titleTextView becomeFirstResponder];
//}

- (IBAction)titleTextFieldEditingChanged:(id)sender {
    self.reportEditor.markEditor.title = self.titleTextView.text;
    self.reportEditor.markEditor.color = self.colorPickerView.color;
}

- (IBAction)subTitleTextFieldEditingChanged:(id)sender {
    self.reportEditor.markEditor.subTitle = self.subTitleTextView.text;
    self.reportEditor.markEditor.color = self.colorPickerView.color;
}

#pragma mark - HTLTodayViewController_New

- (BOOL)editorVisible {
    return _editorVisible;
}

- (void)setEditorVisible:(BOOL)editorVisible {
    _editorVisible = editorVisible;
    [self updateUIAnimated:YES];
}

- (HTLTodayDataSource *)dataSource {
    if (!_dataSource) {
        __weak __typeof(self) weakSelf = self;
        _dataSource = [HTLTodayDataSource dataSourceWithContentChangedBlock:^{
            [weakSelf updateUIAnimated:YES];
        }];
        [weakSelf updateUIAnimated:YES];
    }
    return _dataSource;
}

- (HTLReportEditor *)reportEditor {
    if (!_reportEditor) {
        __weak __typeof(self) weakSelf = self;
        _reportEditor = [HTLReportEditor editorWithChangedBlock:^{
            [weakSelf updateUIAnimated:YES];
        }];
        [weakSelf updateUIAnimated:YES];
    }
    return _reportEditor;
}

- (void)updateUIAnimated:(BOOL)animated {
    if (!self.isViewLoaded) {
        return;
    }

    self.saveButton.enabled = self.reportEditor.report != nil;
    self.customReportDatesLabel.text = [NSString stringWithFormat:@"%@ → %@", self.reportEditor.startDate.shortString, self.reportEditor.endDate.shortString];
    self.customReportDurationLabel.text = HTLDurationFullString([self.reportEditor.endDate timeIntervalSinceDate:self.reportEditor.startDate]);

    self.lastReportView.report = self.dataSource.lastReport;
    BOOL headerVisible = self.lastReportView.report != nil;

    if (self.editorVisible) {
        self.marksCollectionView.dataSource = nil;
        self.marksCollectionView.delegate = nil;
    } else {
        self.marksCollectionView.dataSource = self;
        self.marksCollectionView.delegate = self;
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view layoutIfNeeded];

        if (headerVisible && !weakSelf.editorVisible) {
            weakSelf.centerToSuperviewConstraint.constant = kHeaderHeight;
            weakSelf.headerContainer.hidden = false;
        } else {
            weakSelf.centerToSuperviewConstraint.constant = weakSelf.editorVisible ? kTopContainerHeight : 0;
            weakSelf.headerContainer.hidden = !headerVisible;
        }

        weakSelf.topHeightConstraint.constant = kTopContainerHeight;
        weakSelf.bottomHeightConstraint.constant = weakSelf.view.bounds.size.height - kTopContainerHeight;
        weakSelf.headerHeightConstraint.constant = kHeaderHeight;

        if (weakSelf.editorVisible) {
            [weakSelf.view bringSubviewToFront:weakSelf.centerContainer];
            [weakSelf.view bringSubviewToFront:weakSelf.dimView];
            [weakSelf.view bringSubviewToFront:weakSelf.topContainer];
            [weakSelf.view bringSubviewToFront:weakSelf.bottomContainer];
            weakSelf.topToCenterConstraint.constant = 0;
            weakSelf.centerToBottomConstraint.constant = -weakSelf.centerContainer.frame.size.height;
        } else {
            weakSelf.topToCenterConstraint.constant = weakSelf.topHeightConstraint.constant * 2;
            weakSelf.centerToBottomConstraint.constant = weakSelf.bottomHeightConstraint.constant * 2;
        }

        [UIView animateWithDuration:animated ? 0.5 : 0
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:0.9
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                             weakSelf.dimView.alpha = weakSelf.editorVisible ? 1 : 0;
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

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];

    self.marksCollectionView.dataSource = nil;
    self.marksCollectionView.delegate = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUIAnimated:NO];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.numberOfMarks;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLMark *mark = [self.dataSource markAtIndex:indexPath.row];
    HTLMarkCollectionViewCell *cell = (HTLMarkCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:mark.subTitle.length > 0 ? [HTLMarkCollectionViewCell defaultIdentifierWithSubTitle] : [HTLMarkCollectionViewCell defaultIdentifier] forIndexPath:indexPath];
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
