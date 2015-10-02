//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportViewController.h"
#import "HTLEditReportModelController.h"
#import "HTLCategory.h"
#import "HTLAction.h"
#import "HTLReportExtended.h"
#import "HTLCompletion.h"
#import "HTLCategoryCell.h"
#import "HTLCompletionCollectionViewCell.h"
#import "HTLReport.h"
#import "HTLReport+Helpers.h"
#import "HyperTimeLogger-Swift.h"


static NSString *const kCompletionCellIdentifier = @"CompletionCell";
static NSString *const kCategoryCellIdentifier = @"CategoryCell";


@interface HTLEditReportViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) HTLEditReportModelController *modelController;

@property(nonatomic, weak) IBOutlet UICollectionView *completionsCollectionView;
@property(nonatomic, weak) IBOutlet UIButton *startDateButton;
@property(nonatomic, weak) IBOutlet UIButton *endDateButton;
@property(nonatomic, weak) IBOutlet UICollectionView *categoriesCollectionView;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)startDateButtonAction:(id)sender;

- (IBAction)endDateButtonAction:(id)sender;

- (IBAction)textFieldEditingChanged:(id)sender;

- (IBAction)textFieldDidEndOnExitAction:(id)sender;

- (IBAction)cancelButtonAction:(id)sender;

- (IBAction)doneButtonAction:(id)sender;

- (void)updateUI;

- (void)save;

- (void)dismiss;

- (void)subscribe;

- (void)unsubscribe;

- (void)selectCategory:(HTLCategory *)category;

- (void)selectCompletion:(HTLCompletion *)completion;

@end

@implementation HTLEditReportViewController

- (IBAction)startDateButtonAction:(id)sender {
    // Nothing
}

- (IBAction)endDateButtonAction:(id)sender {
    // Nothing
}

- (IBAction)textFieldEditingChanged:(id)sender {
    self.modelController.action = [HTLAction actionWithIdentifier:[NSUUID UUID].UUIDString
                                                            title:self.textField.text];
    [self.completionsCollectionView reloadData];
}

- (IBAction)textFieldDidEndOnExitAction:(id)sender {
    if (self.textField.text.length == 0) {
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

- (void)updateUI {
    HTLReportExtended *reportExtended = self.modelController.reportExtended;
    if (!reportExtended) {
        return;
    }

    self.textField.text = reportExtended.action.title;

    [self.startDateButton setTitle:reportExtended.report.startDateString forState:UIControlStateNormal];
    [self.endDateButton setTitle:reportExtended.report.endDateString forState:UIControlStateNormal];

    NSUInteger selectedCategoryIndex = [self.modelController.categories indexOfObject:reportExtended.category];
    NSIndexPath *selectedCategoryIndexPath = [NSIndexPath indexPathForRow:selectedCategoryIndex inSection:0];
    [self.categoriesCollectionView selectItemAtIndexPath:selectedCategoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)save {
    [self.modelController save];
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
        weakSelf.bottomConstraint.constant = weakSelf.view.bounds.size.height - frameEnd.origin.y;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)selectCategory:(HTLCategory *)category {
    self.modelController.category = category ? category : self.modelController.categories.firstObject;
}

- (void)selectCompletion:(HTLCompletion *)completion {
    if (!completion) {
        return;
    }
    self.modelController.action = completion.action;
    self.modelController.category = completion.category;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof(self) weakSelf = self;
    self.modelController =
            [HTLEditReportModelController modelControllerWithReportExtended:self.reportExtended
                                                        contentChangedBlock:^{
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [weakSelf.completionsCollectionView reloadData];
                                                                [weakSelf.categoriesCollectionView reloadData];

                                                                [weakSelf updateUI];
                                                            });
                                                        }];

    if ([self.completionsCollectionView.collectionViewLayout isKindOfClass:[ZLBalancedFlowLayout class]]) {
        ZLBalancedFlowLayout *balancedFlowLayout = (ZLBalancedFlowLayout *) self.completionsCollectionView.collectionViewLayout;
        balancedFlowLayout.minimumLineSpacing = 0;
        balancedFlowLayout.minimumInteritemSpacing = 0;
        balancedFlowLayout.rowHeight = 40;
        balancedFlowLayout.enforcesRowHeight = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribe];
    [self updateUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribe];
    [super viewDidDisappear:animated];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.categoriesCollectionView == collectionView) {
        return self.modelController.categories.count;
    }
    return self.modelController.completions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        HTLCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellIdentifier forIndexPath:indexPath];
        [cell configureWithCategory:self.modelController.categories[(NSUInteger) indexPath.row]];
        return cell;

    } else {
        HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
        [cell configureWithCompletion:self.modelController.completions[(NSUInteger) indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        [self selectCategory:self.modelController.categories[(NSUInteger) indexPath.row]];

    } else {
        [self selectCompletion:self.modelController.completions[(NSUInteger) indexPath.row]];
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

@end