//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLEditCategoryViewController.h"
#import "HTLCategoryEditor.h"


@interface HTLEditCategoryViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, weak) IBOutlet UITextField *titleTextField;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;

@property(nonatomic, strong, readonly) HTLCategoryEditor *editor;
@property(nonatomic, strong, readonly) NSArray *colors;

@end

@implementation HTLEditCategoryViewController
@dynamic originalCategory;
@synthesize editor = editor_;
@synthesize colors = colors_;

#pragma mark - HTLEditCategoryViewController_New @IB

- (IBAction)saveButtonAction:(id)sender {
    [self.delegate editCategoryViewController:self finishedWithCategory:self.editor.updatedCategory];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate editCategoryViewController:self finishedWithCategory:nil];
}

- (IBAction)titleTextFieldEditingChanged:(id)sender {
    self.editor.title = self.titleTextField.text;
    [self reloadData];
}

#pragma mark - HTLEditCategoryViewController_New

- (HTLCategory *)originalCategory {
    return self.editor.originalCategory;
}

- (void)setOriginalCategory:(HTLCategory *)originalCategory {
    [self.editor setOriginalCategory:originalCategory];
    [self reloadData];
}

- (HTLCategoryEditor *)editor {
    if (!editor_) {
        editor_ = [HTLCategoryEditor new];
    }
    return editor_;
}

- (NSArray *)colors {
    if (!colors_) {
        colors_ = @[
                @{@"title" : @"Red", @"color" : [UIColor paperColorRed]},
                @{@"title" : @"Pink", @"color" : [UIColor paperColorPink]},
                @{@"title" : @"Purple", @"color" : [UIColor paperColorPurple]},
                @{@"title" : @"Deep Purple", @"color" : [UIColor paperColorDeepPurple]},
                @{@"title" : @"Indigo", @"color" : [UIColor paperColorIndigo]},
                @{@"title" : @"Blue", @"color" : [UIColor paperColorBlue]},
                @{@"title" : @"Light Blue", @"color" : [UIColor paperColorLightBlue]},
                @{@"title" : @"Cyan", @"color" : [UIColor paperColorCyan]},
                @{@"title" : @"Teal", @"color" : [UIColor paperColorTeal]},
                @{@"title" : @"Green", @"color" : [UIColor paperColorGreen]},
                @{@"title" : @"Light Green", @"color" : [UIColor paperColorLightGreen]},
                @{@"title" : @"Lime", @"color" : [UIColor paperColorLime]},
                @{@"title" : @"Yellow", @"color" : [UIColor paperColorYellow]},
                @{@"title" : @"Amber", @"color" : [UIColor paperColorAmber]},
                @{@"title" : @"Orange", @"color" : [UIColor paperColorOrange]},
                @{@"title" : @"Deep Orange", @"color" : [UIColor paperColorDeepOrange]},
                @{@"title" : @"Brown", @"color" : [UIColor paperColorBrown]},
                @{@"title" : @"Gray", @"color" : [UIColor paperColorGray]},
                @{@"title" : @"BlueGray", @"color" : [UIColor paperColorBlueGray]}
        ];
    }
    return colors_;
}

- (void)reloadData {
    if (!self.isViewLoaded) {
        return;
    }

    self.saveButton.enabled = self.editor.canSave;
    self.titleTextField.text = self.editor.title;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.colors.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *colorLabel = (UILabel *) view;
    if (!colorLabel) {
        colorLabel = [UILabel new];
        colorLabel.textAlignment = NSTextAlignmentCenter;
    }

    NSDictionary *colorDescriptor = self.colors[(NSUInteger) row];
    colorLabel.text = colorDescriptor[@"title"];
    colorLabel.backgroundColor = colorDescriptor[@"color"];

    return colorLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *colorDescriptor = self.colors[(NSUInteger) row];
    self.editor.color = colorDescriptor[@"color"];
    [self reloadData];
}

@end