//
// Created by Maxim Pervushin on 30/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: SettingsViewController @IB

    @IBOutlet weak var remindersEnabledSwitch: UISwitch?
    @IBOutlet weak var remindersIntervalPicker: UIDatePicker?
    @IBOutlet weak var localNotificationsIntervalCell: UITableViewCell?

    @IBAction func doneButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func remindersEnabledSwitchValueChanged(sender: AnyObject) {
        if let sender = sender as? UISwitch {
            HTLApp.remindersManager().enabled = sender.on
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    @IBAction func remindersIntervalPickerValueChanged(sender: AnyObject) {
        if let sender = sender as? UIDatePicker {
            let components = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: sender.date)
            let interval = Double(components.hour * 60 * 60 + components.minute * 60)
            HTLApp.remindersManager().interval = interval
        }
    }

    @IBAction func exportToCSVButtonAction(sender: AnyObject) {
        let csv = dataSource.exportDataToCSV()
        if csv.characters.count == 0 {
            let title = NSLocalizedString("Export to CSV", comment: "")
            let message = NSLocalizedString("There is no data to export.", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let title = NSLocalizedString("Export to CSV", comment: "")
            let message = NSLocalizedString("", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            if MFMailComposeViewController.canSendMail() {
                alert.addAction(UIAlertAction(title: NSLocalizedString("Send Mail", comment: ""), style: .Default, handler: {
                    _ in
                    self.sendMailCSV(csv)
                }))
            }

            alert.addAction(UIAlertAction(title: NSLocalizedString("Copy to Pasteboard", comment: ""), style: .Default, handler: {
                _ in
                self.copyCSV(csv)
            }))

            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))

            presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func resetContentButtonAction(sender: AnyObject) {
        let title = NSLocalizedString("Reset content", comment: "")
        let message = NSLocalizedString("Are you sure want to reset all data?", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: ""), style: .Destructive, handler: {
            _ in
            self.dataSource.resetContent()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func resetDefaultsButtonAction(sender: AnyObject) {
        let title = NSLocalizedString("Reset defaults", comment: "")
        let message = NSLocalizedString("Are you sure want to reset all defaults?", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: ""), style: .Destructive, handler: {
            _ in
            self.dataSource.resetDefaults()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: UITableViewController

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let remindersEnabledSwitch = remindersEnabledSwitch where indexPath.section == 0 && indexPath.row == 2 {
            return remindersEnabledSwitch.on ? 216 : 0
        }
        return indexPath.row == 0 ? 22 : 44
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        if HTLApp.versionIdentifier() != "" {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.generateTestDataGesture(_:)))
            gestureRecognizer.numberOfTapsRequired = 7
            gestureRecognizer.numberOfTouchesRequired = 2
            tableView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: private

    private let dataSource = HTLSettingsDataSource()
    
    private func updateUI() {
        remindersEnabledSwitch?.on = HTLApp.remindersManager().enabled

        let components = NSDateComponents()
        components.second = Int(HTLApp.remindersManager().interval)
        if let date = NSCalendar.currentCalendar().dateFromComponents(components) {
            remindersIntervalPicker?.date = date
        }
    }

    @objc private func generateTestDataGesture(sender: AnyObject) {
        dataSource.generateTestData()
    }
    
    private func sendMailCSV(csv: String) {
        guard let data = csv.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setSubject(NSLocalizedString("Data export from Time Logger", comment: ""))
        mailComposeViewController.setMessageBody(NSLocalizedString("Look at files attached", comment: ""), isHTML: false)
        mailComposeViewController.addAttachmentData(data, mimeType: "text/csv", fileName: "export.csv")
        presentViewController(mailComposeViewController, animated: true, completion: nil)
    }

    private func copyCSV(csv: String) {
        UIPasteboard.generalPasteboard().string = csv
    }

    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
