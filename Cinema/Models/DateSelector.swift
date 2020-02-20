//
//  DateSelector.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

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
        self.dates = Date().datesInFuture(after: 14)
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
    ///
    fileprivate func datesInFuture(after days: Int) -> [Date] {
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
