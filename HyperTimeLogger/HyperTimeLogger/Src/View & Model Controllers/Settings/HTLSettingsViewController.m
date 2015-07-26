//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsViewController.h"
#import "HTLSettingsModelController.h"
#import "HTLSettingsModelController+TestData.h"
#import "HTLAppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface HTLSettingsViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UIButton *exportToCSVButton;

@property(nonatomic, weak) IBOutlet UIButton *generateTestDataButton;

@property(nonatomic, strong) HTLSettingsModelController *modelController;

- (IBAction)doneButtonAction:(id)sender;

- (IBAction)resetContentButtonAction:(id)sender;

- (IBAction)resetDefaultsButtonAction:(id)sender;

- (IBAction)exportToCSVButtonAction:(id)sender;

- (IBAction)generateTestDataButtonAction:(id)sender;

- (void)generateTestData;

@end

@implementation HTLSettingsViewController

#pragma mark - HTLSettingsViewController

- (IBAction)doneButtonAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)resetContentButtonAction:(id)sender {
    [self.modelController resetContent];
}

- (IBAction)resetDefaultsButtonAction:(id)sender {
    [self.modelController resetDefaults];
}

- (IBAction)exportToCSVButtonAction:(id)sender {
    NSString *csv = [self.modelController exportDataToCSV];
    if (csv.length == 0) {
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Export CSV"
                                                                             message:@"Test"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    if ([MFMailComposeViewController canSendMail]) {
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Send Mail", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
            mailComposeViewController.mailComposeDelegate = self;
            [mailComposeViewController setSubject:@"Data export from Time Logger"];
            [mailComposeViewController setMessageBody:@"Look at files attached" isHTML:NO];
            [mailComposeViewController addAttachmentData:[csv dataUsingEncoding:NSUTF8StringEncoding]
                                                mimeType:@"text/csv"
                                                fileName:@"export.csv"];
            [self presentViewController:mailComposeViewController animated:YES completion:nil];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy to Pasteboard", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [UIPasteboard generalPasteboard].string = csv;
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)generateTestDataButtonAction:(id)sender {
    [self generateTestData];
}

- (void)generateTestData {
    [self.modelController generateTestData];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelController = [HTLSettingsModelController modelControllerWithContentChangedBlock:nil];
    self.generateTestDataButton.hidden = [HTLAppVersion isEqualToString:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.exportToCSVButton.hidden = ![MFMailComposeViewController canSendMail];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        DDLogError(@"%@", error.localizedDescription);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

