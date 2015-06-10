//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsViewController.h"
#import "HTLSettingsModelController.h"
#import <MessageUI/MessageUI.h>

@interface HTLSettingsViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) HTLSettingsModelController *modelController;

- (IBAction)doneButtonAction:(id)sender;

- (IBAction)resetContentButtonAction:(id)sender;

- (IBAction)resetDefaultsButtonAction:(id)sender;

- (IBAction)exportToCSVButtonAction:(id)sender;

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

    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:@"Data export from Time Logger"];
    [mailComposeViewController setMessageBody:@"Look at files attached" isHTML:NO];
    [mailComposeViewController addAttachmentData:[csv dataUsingEncoding:NSUTF8StringEncoding]
                                        mimeType:@"text/csv"
                                        fileName:@"export.csv"];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelController = [HTLSettingsModelController new];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        DDLogError(@"%@", error.localizedDescription);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

