//
//  DateSelector.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

protocol DateSelectable {
    var dates: [Date] { get }
    var selectedDate: Date { get }
    var currentIndex: Int { get }
    
    mutating func previousDate()
    mutating func nextDate()
}

struct DateSelector: DateSelectable {
    
    static let isFirstDateSelectedKey = "DateSelectorIsFirstDateSelected"
    
    let dates: [Date]
    
    var selectedDate: Date {
        return dates[currentIndex]
    }
    
    private(set) var currentIndex = 0 {
        didSet {
            postNotification()
        }
    }
    
    private var isFirstDateSelected: Bool {
        return currentIndex == 0 ? true : false
    }
    
    init() {
        self.dates = Date().datesInFuture(after: 14)
    }
    
    private func postNotification() {
        let info = [DateSelector.isFirstDateSelectedKey : isFirstDateSelected]
        NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil, userInfo: info)
    }
    
    mutating func previousDate() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    mutating func nextDate() {
        guard let lastIndex = dates.indices.last else { fatalError("Date array is empty!") }
        
        if currentIndex != lastIndex {
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
