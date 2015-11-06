//
// Created by Maxim Pervushin on 06/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditReportTableViewController.h"
#import "HTLReportEditor.h"
#import "HTLMarkEditor.h"
#import "HTLColorPickerCollectionView.h"
#import "NSDate+HTL.h"
#import "HTLReport.h"


@interface HTLEditReportTableViewController () <HTLColorPickerCollectionViewDelegate> {
    HTLReportEditor *_reportEditor;
}

@property(nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;
@property(nonatomic, weak) IBOutlet UILabel *reportDatesLabel;
@property(nonatomic, weak) IBOutlet UILabel *reportDurationLabel;
@property(nonatomic, weak) IBOutlet UITextField *titleTextField;
@property(nonatomic, weak) IBOutlet UITextField *subTitleTextField;
@property(nonatomic, weak) IBOutlet HTLColorPickerCollectionView *colorPicker;

@end

@implementation HTLEditReportTableViewController
@dynamic reportEditor;

#pragma mark - HTLEditReportTableViewController @IB

- (IBAction)saveButtonAction:(id)sender {
    [self.delegate editReportTableViewController:self didFinishEditingWithReport:self.reportEditor.report];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate editReportTableViewControllerDidCancel:self];
}

- (IBAction)titleTextFieldEditingChanged:(id)sender {
    self.reportEditor.markEditor.title = self.titleTextField.text;
}

- (IBAction)subTitleTextFieldEditingChanged:(id)sender {
    self.reportEditor.markEditor.subTitle = self.subTitleTextField.text;
}

#pragma mark - HTLEditReportTableViewController

- (HTLReportEditor *)reportEditor {
    if (!_reportEditor) {
        __weak __typeof(self) weakSelf = self;
        _reportEditor = [HTLReportEditor editorWithChangedBlock:^{
            [weakSelf updateUI];
        }];
    }
    return _reportEditor;
}

- (void)updateUI {
    if (!self.isViewLoaded) {
        return;
    }

    self.saveButton.enabled = self.reportEditor.report != nil;
    self.reportDatesLabel.text = [NSString stringWithFormat:@"%@ → %@", self.reportEditor.startDate.shortString, self.reportEditor.endDate.shortString];
    self.reportDurationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Duration: %@", @"Duration Format"), HTLDurationFullString([self.reportEditor.endDate timeIntervalSinceDate:self.reportEditor.startDate])] ;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorPicker.colorPickerDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.reportEditor.markEditor.color = self.colorPicker.color;
    [self.titleTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleTextField resignFirstResponder];
    [self.subTitleTextField resignFirstResponder];
}

#pragma mark - HTLColorPickerCollectionViewDelegate

- (void)colorPickerCollectionView:(HTLColorPickerCollectionView *)colorPickerCollectionView didSelectColor:(UIColor *)color {
    self.reportEditor.markEditor.color = color;
}

@end