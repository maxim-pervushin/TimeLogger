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
    }
    
    /// Required method to implement!
    public func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    public func firstWeekday() -> Weekday {
        return .Monday
    }
    
    public func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    public func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    public func didSelectDayView(dayView: DayView) {
        if let date = dayView.date.convertedDate() {
            datePickerDelegate?.datePickerViewController(self, didPickDate: date)
        }
    }
    
//    public func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
//        if let date = dayView.date.convertedDate() {
//            datePickerDelegate?.datePickerViewController(self, didPickDate: date)
//        }
//    }

}
