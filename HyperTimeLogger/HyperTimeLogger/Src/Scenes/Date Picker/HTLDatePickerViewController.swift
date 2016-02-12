//
// Created by Maxim Pervushin on 10/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

//public protocol HTLDatePickerViewControllerDelegate: class {

@objc public protocol HTLDatePickerViewControllerDelegate {
    func datePickerViewControllerDidCancel(viewController: HTLDatePickerViewController)

    func datePickerViewController(viewController: HTLDatePickerViewController, didPickDate date: NSDate)
}

public final class HTLDatePickerViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {

    // MARK: - @IB HTLDatePickerViewController

    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!

    @IBAction func cancelButtonAction(sender: AnyObject) {
        datePickerDelegate?.datePickerViewControllerDidCancel(self)
    }

    // MARK: - HTLDatePickerViewController

    public weak var datePickerDelegate: HTLDatePickerViewControllerDelegate?

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarMenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        updateTitle()
    }

    private func updateTitle() {
        if let date = calendarView.presentedDate.convertedDate() {
            title = date.stringWithFormat("MMMM, yyyy")
        }
    }

    // MARK: - CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate

    public func presentationMode() -> CalendarMode {
        return .MonthView
    }

    public func firstWeekday() -> Weekday {
        return .Monday
    }

    public func shouldShowWeekdaysOut() -> Bool {
        return false
    }

    public func shouldAnimateResizing() -> Bool {
        return false
    }

    public func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }

    public func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }

    public func didSelectDayView(dayView: DayView) {
        if let date = dayView.date.convertedDate() {
            datePickerDelegate?.datePickerViewController(self, didPickDate: date)
        }
    }

    public func presentedDateUpdated(date: CVDate) {
        updateTitle()
    }
}
