//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportViewController.h"
#import "HTLActionDto.h"
#import "HTLCategoryCell.h"
#import "HTLCategoryDto.h"
#import "HTLCompletionCollectionViewCell.h"
#import "HTLCompletionDto.h"
#import "HTLEditReportModelController.h"
#import "HTLReportDto+Helpers.h"
#import "HTLReportExtendedDto.h"
#import "HTLReportExtendedEditor.h"
#import "HyperTimeLogger-Swift.h"

static NSString *const kCompletionCellIdentifier = @"CompletionCell";
static NSString *const kCategoryCellIdentifier = @"CategoryCell";


@interface HTLEditReportViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HTLLineLayoutDelegate> {
    HTLEditReportModelController *_modelController;
    HTLReportExtendedEditor *_editor;
}

@property(nonatomic, readonly) HTLEditReportModelController *modelController;
@property(nonatomic, readonly) HTLReportExtendedEditor *editor;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *containerBottomConstraint;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;
@property(nonatomic, weak) IBOutlet UICollectionView *completionsCollectionView;
@property(nonatomic, weak) IBOutlet UIButton *startDateButton;
@property(nonatomic, weak) IBOutlet UIDatePicker *startDatePicker;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *startDateContainerHeightConstraint;
@property(nonatomic, weak) IBOutlet UIButton *endDateButton;
@property(nonatomic, weak) IBOutlet UIDatePicker *endDatePicker;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *endDateContainerHeightConstraint;
@property(nonatomic, weak) IBOutlet UICollectionView *categoriesCollectionView;
@property(nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)startDateButtonAction:(id)sender;

- (IBAction)endDateButtonAction:(id)sender;

- (IBAction)textFieldEditingChanged:(id)sender;

- (IBAction)textFieldDidEndOnExitAction:(id)sender;

- (IBAction)cancelButtonAction:(id)sender;

- (IBAction)doneButtonAction:(id)sender;

- (IBAction)startDatePickerValueChanged:(id)sender;

- (IBAction)endDatePickerValueChanged:(id)sender;

- (void)updateUI;

- (void)save;

- (void)dismiss;

- (void)subscribe;

- (void)unsubscribe;

- (void)selectCategory:(HTLCategoryDto *)category;

- (void)selectCompletion:(HTLCompletionDto *)completion;

@end

@implementation HTLEditReportViewController
@dynamic reportExtended;

#pragma mark - HTLEditReportViewController @IB

- (IBAction)startDateButtonAction:(id)sender {
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
    [self setStartDatePickerVisible:!self.startDatePickerVisible animated:YES];
    [self setEndDatePickerVisible:NO animated:YES];
}

- (IBAction)endDateButtonAction:(id)sender {
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
    [self setEndDatePickerVisible:!self.endDatePickerVisible animated:YES];
    [self setStartDatePickerVisible:NO animated:YES];
}

- (IBAction)textFieldEditingChanged:(id)sender {
    self.editor.action = [HTLActionDto actionWithIdentifier:[NSUUID UUID].UUIDString
                                                      title:self.textField.text];
    [self.completionsCollectionView reloadData];
}

- (IBAction)textFieldDidEndOnExitAction:(id)sender {
    if (!self.editor.canSave) {
        return;
    }

    [self save];
    [self dismiss];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismiss];
}

- (IBAction)doneButtonAction:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }

    [self save];
    [self dismiss];
}

- (IBAction)startDatePickerValueChanged:(id)sender {
    self.editor.reportStartDate = self.startDatePicker.date;
}

- (IBAction)endDatePickerValueChanged:(id)sender {
    self.editor.reportEndDate = self.endDatePicker.date;
}

#pragma mark - HTLEditReportViewController public

- (void)setReportExtended:(HTLReportExtendedDto *)reportExtended {
    self.editor.originalReportExtended = reportExtended;
}

- (HTLReportExtendedDto *)reportExtended {
    return self.editor.originalReportExtended;
}

#pragma mark - HTLEditReportViewController private

- (HTLEditReportModelController *)modelController {
    if (!_modelController) {
        __weak __typeof(self) weakSelf = self;
        _modelController = [HTLEditReportModelController modelControllerWithContentChangedBlock:^{
            [weakSelf updateUI];
        }];
    }
    return _modelController;
}

- (HTLReportExtendedEditor *)editor {
    if (!_editor) {
        __weak __typeof(self) weakSelf = self;
        _editor = [HTLReportExtendedEditor editorWithChangedBlock:^{
            [weakSelf updateUI];
        }];
    }
    return _editor;
}

- (BOOL)startDatePickerVisible {
    return self.startDateContainerHeightConstraint.constant > self.startDateButton.frame.size.height;
}

- (BOOL)endDatePickerVisible {
    return self.endDateContainerHeightConstraint.constant > self.endDateButton.frame.size.height;
}

- (void)setStartDatePickerVisible:(BOOL)visible animated:(BOOL)animated {
    if (visible == self.startDatePickerVisible) {
        return;
    }
    [self.view layoutIfNeeded];
    if (visible) {
        self.startDateContainerHeightConstraint.constant = self.startDateButton.frame.size.height + self.startDatePicker.frame.size.height;
    } else {
        self.startDateContainerHeightConstraint.constant = self.startDateButton.frame.size.height;
    }
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        [self.view layoutIfNeeded];
        self.startDatePicker.alpha = visible ? 1 : 0;
    }];
}

- (void)setEndDatePickerVisible:(BOOL)visible animated:(BOOL)animated {
    if (visible == self.endDatePickerVisible) {
        return;
    }
    [self.view layoutIfNeeded];
    if (visible) {
        self.endDateContainerHeightConstraint.constant = self.endDateButton.frame.size.height + self.endDatePicker.frame.size.height;
    } else {
        self.endDateContainerHeightConstraint.constant = self.endDateButton.frame.size.height;
    }
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        [self.view layoutIfNeeded];
        self.endDatePicker.alpha = visible ? 1 : 0;
    }];
}

- (void)updateUI {
    HTLReportExtendedDto *reportExtended = self.editor.updatedReportExtended;
    if (!reportExtended) {
        reportExtended = self.editor.originalReportExtended;
        if (!reportExtended) {
            return;
        }
    }

    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        weakSelf.saveButton.enabled = weakSelf.editor.canSave;

        weakSelf.textField.text = reportExtended.action.title;

        [weakSelf.startDateButton setTitle:reportExtended.report.startDateString forState:UIControlStateNormal];
        weakSelf.startDatePicker.date = reportExtended.report.startDate;
        [weakSelf.endDateButton setTitle:reportExtended.report.endDateString forState:UIControlStateNormal];
        weakSelf.endDatePicker.date = reportExtended.report.endDate;

        [weakSelf.completionsCollectionView reloadData];
        [weakSelf.categoriesCollectionView reloadData];

        NSUInteger selectedCategoryIndex = [weakSelf.modelController.categories indexOfObject:reportExtended.category];
        NSIndexPath *selectedCategoryIndexPath = [NSIndexPath indexPathForRow:selectedCategoryIndex inSection:0];
        [weakSelf.categoriesCollectionView selectItemAtIndexPath:selectedCategoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    });
}

- (void)save {
    if (self.editor.updatedReportExtended) {
        [self.modelController saveReportExtended:self.editor.updatedReportExtended];
    }
}

- (void)dismiss {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        CGRect frameEnd = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        weakSelf.containerBottomConstraint.constant = weakSelf.view.bounds.size.height - frameEnd.origin.y;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)selectCategory:(HTLCategoryDto *)category {
    self.editor.category = category ? category : self.modelController.categories.firstObject;
}

- (void)selectCompletion:(HTLCompletionDto *)completion {
    if (!completion) {
        return;
    }
    self.editor.action = completion.action;
    self.editor.category = completion.category;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.categoriesCollectionView.collectionViewLayout isKindOfClass:[HTLLineLayout class]]) {
        HTLLineLayout *lineLayout = (HTLLineLayout *) self.categoriesCollectionView.collectionViewLayout;
        lineLayout.delegate = self;
    }

    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStartDatePickerVisible:NO animated:NO];
    [self setEndDatePickerVisible:NO animated:NO];
    [self subscribe];
    [self updateUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribe];
    [super viewDidDisappear:animated];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.categoriesCollectionView == collectionView) {
        return self.modelController.categories.count;
    }
    return [self.modelController completionsForAction:self.editor.action].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        HTLCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellIdentifier forIndexPath:indexPath];
        [cell configureWithCategory:self.modelController.categories[(NSUInteger) indexPath.row]];
        return cell;

    } else {
        HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
        [cell configureWithCompletion:[self.modelController completionsForAction:self.editor.action][(NSUInteger) indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        [self selectCategory:self.modelController.categories[(NSUInteger) indexPath.row]];

    } else {
        [self selectCompletion:[self.modelController completionsForAction:self.editor.action][(NSUInteger) indexPath.row]];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        CGFloat width = [HTLCategoryCell widthWithCategory:self.modelController.categories[(NSUInteger) indexPath.row]];
        return CGSizeMake(width, collectionView.bounds.size.height);

    } else {
        return CGSizeMake(collectionView.bounds.size.width / 2, 40);
    }
}

#pragma mark - HTLLineLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HTLLineLayout *)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLCategoryCell widthWithCategory:self.modelController.categories[(NSUInteger) indexPath.row]];
}

@end