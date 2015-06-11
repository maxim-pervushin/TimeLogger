//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCreateReportViewController.h"
#import "HTLCreateReportModelController.h"
#import "HTLCategoryDto.h"
#import "HTLActionDto.h"
#import "HTLCompletion.h"
#import "HTLCompletionTableViewCell.h"
#import "HTLCategoryCell.h"
#import "HTLReportExtendedDto.h"
#import "HTLCompletionCollectionViewCell.h"
#import <ZLBalancedFlowLayout/ZLBalancedFlowLayout-Swift.h>


static NSString *const kCompletionCellIdentifier = @"CompletionCell";
static NSString *const kCategoryCellIdentifier = @"CategoryCell";


@interface HTLCreateReportViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) HTLCreateReportModelController *modelController;
@property(nonatomic, strong) NSString *text;

@property(nonatomic, weak) IBOutlet UITableView *completionsTableView;
@property(nonatomic, weak) IBOutlet UICollectionView *completionsCollectionView;
@property(nonatomic, weak) IBOutlet UICollectionView *categoriesCollectionView;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)textFieldEditingChanged:(id)sender;

- (IBAction)textFieldDidEndOnExitAction:(id)sender;

- (IBAction)cancelButtonAction:(id)sender;

- (IBAction)doneButtonAction:(id)sender;

- (void)createReport;

- (void)dismiss;

@end

@implementation HTLCreateReportViewController

- (IBAction)textFieldEditingChanged:(id)sender {
    self.text = self.textField.text;
    [self.completionsTableView reloadData];
    [self.completionsCollectionView reloadData];
}

- (IBAction)textFieldDidEndOnExitAction:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }

    [self createReport];
    [self dismiss];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismiss];
}

- (IBAction)doneButtonAction:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }

    [self createReport];
    [self dismiss];
}

- (void)createReport {
    HTLCategoryDto *category;
    NSIndexPath *selectedCategoryIndexPath = self.categoriesCollectionView.indexPathsForSelectedItems.firstObject;
    if (selectedCategoryIndexPath) {
        category = self.modelController.getCategories[(NSUInteger) selectedCategoryIndexPath.row];
    } else {
        category = self.modelController.getCategories.firstObject;
    }

    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[NSUUID UUID].UUIDString title:self.textField.text];
    HTLReportExtendedDto *reportExtended = [HTLReportExtendedDto reportWithAction:action
                                                                         category:category
                                                                        startDate:self.modelController.lastReportEndDate
                                                                          endDate:[NSDate new]];

    if (![self.modelController createReportExtended:reportExtended]) {
        NSLog(@"Unable to create");
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
        weakSelf.bottomConstraint.constant = weakSelf.view.bounds.size.height - frameEnd.origin.y;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelController = [HTLCreateReportModelController new];

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
    [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribe];
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelController getCompletionsForText:self.text].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLCompletionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
    [cell configureWithCompletion:[self.modelController getCompletionsForText:self.text][(NSUInteger) indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HTLCompletion *completion = [self.modelController getCompletionsForText:self.text][(NSUInteger) indexPath.row];
    self.textField.text = completion.action.title;

    NSUInteger selectedCategoryIndex = [[self.modelController getCategories] indexOfObject:completion.category];
    NSIndexPath *selectedCategoryIndexPath = [NSIndexPath indexPathForRow:selectedCategoryIndex inSection:0];
    [self.categoriesCollectionView selectItemAtIndexPath:selectedCategoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.categoriesCollectionView == collectionView) {
        return [self.modelController getCategories].count;
    }
    return [self.modelController getCompletionsForText:self.text].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        HTLCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellIdentifier forIndexPath:indexPath];
        [cell configureWithCategory:[self.modelController getCategories][(NSUInteger) indexPath.row]];
        return cell;
    }

    HTLCompletionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompletionCellIdentifier forIndexPath:indexPath];
    [cell configureWithCompletion:[self.modelController getCompletionsForText:self.text][(NSUInteger) indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        HTLCompletion *completion = [self.modelController getCompletionsForText:self.text][(NSUInteger) indexPath.row];
        self.textField.text = completion.action.title;

        NSUInteger selectedCategoryIndex = [[self.modelController getCategories] indexOfObject:completion.category];
        NSIndexPath *selectedCategoryIndexPath = [NSIndexPath indexPathForRow:selectedCategoryIndex inSection:0];
        [self.categoriesCollectionView selectItemAtIndexPath:selectedCategoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesCollectionView == collectionView) {
        CGFloat width = [HTLCategoryCell widthWithCategory:[self.modelController getCategories][(NSUInteger) indexPath.row]];
        return CGSizeMake(width, collectionView.bounds.size.height);
    }

    return CGSizeMake(collectionView.bounds.size.width / 2, 40);
}

@end