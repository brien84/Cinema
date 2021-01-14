//
//  DateSelector.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

protocol DateSelectable {
    var current: Date { get }
    var isFirst: Bool { get }
    var isLast: Bool { get }

    func previous()
    func next()
}

final class DateSelector: DateSelectable {

    private let dates: [Date]

    private var currentIndex = 0 {
        didSet {
            postNotification()
        }
    }

    var current: Date {
        return dates[currentIndex]
    }

    var isFirst: Bool {
        return currentIndex == 0
    }

    var isLast: Bool {
        return currentIndex == dates.indices.last
    }

    init() {
        if CommandLine.arguments.contains("ui-testing") {
            // Testing start date is 2030-02-14.
            self.dates = Date(timeIntervalSince1970: 1897328436).futureDatesIn(days: 10)
        } else {
            self.dates = Date().futureDatesIn(days: 10)
        }
    }

    private func postNotification() {
        NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil)
    }

    func previous() {
        if !isFirst {
            currentIndex -= 1
        }
    }

    func next() {
        if !isLast {
            currentIndex += 1
        }
    }
}

extension Date {
    /// Creates array of `Date` by adding one day to the date provided number of times.
    ///
    /// - Example:
    ///     ~~~
    ///     let dates = futureDatesIn(after: 2)
    ///     print(dates)
    ///     // Prints "[2020-02-22 16:37:31 +0000,
    ///     //          2020-02-23 16:37:31 +0000,
    ///     //          2020-02-24 16:37:31 +0000]"
    ///     ~~~
    fileprivate func futureDatesIn(days: Int) -> [Date] {
        var date = self
        guard let endDate = Calendar.current.date(byAdding: .day, value: days, to: date) else { return [] }
        var dates = [Date]()

        while date <= endDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return [] }
            date = newDate
        }

        return dates
    }
}

extension Notification.Name {
    static let DateSelectorDateDidChange = Notification.Name("DateSelectorDateDidChangNotification")
}
