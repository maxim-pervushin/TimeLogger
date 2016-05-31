//
// Created by Maxim Pervushin on 30/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController {

    // MARK: SettingsViewController @IB

    @IBOutlet weak var remindersEnabledSwitch: UISwitch?
    @IBOutlet weak var remindersIntervalPicker: UIDatePicker?
    @IBOutlet weak var localNotificationsIntervalCell: UITableViewCell?

    @IBAction func remindersEnabledSwitchValueChanged(sender: AnyObject) {
        if let sender = sender as? UISwitch {
            HTLApp.remindersManager().enabled = sender.on
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func notificationsIntervalPickerValueChanged(sender: AnyObject) {
        if let sender = sender as? UIDatePicker {
            let components = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: sender.date)
            let interval = Double(components.hour * 60 * 60 + components.minute * 60)
            HTLApp.remindersManager().interval = interval
        }
    }

    // MARK: UITableViewController

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let remindersEnabledSwitch = remindersEnabledSwitch where indexPath.section == 0 && indexPath.row == 2 {
            return remindersEnabledSwitch.on ? 216 : 0
        }
        return indexPath.row == 0 ? 22 : 44
    }

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: private

    private func updateUI() {
        remindersEnabledSwitch?.on = HTLApp.remindersManager().enabled

        let components = NSDateComponents()
        components.second = Int(HTLApp.remindersManager().interval)
        if let date = NSCalendar.currentCalendar().dateFromComponents(components) {
            remindersIntervalPicker?.date = date
        }
    }
}
