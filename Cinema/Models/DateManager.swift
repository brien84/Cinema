//
//  DateManager.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

class DateManager {
    
    private let dates: [Date]
    
    private var currentIndex = 0 {
        didSet {
            let info = self.currentIndex == 0 ? [Constants.UserInfo.isIndexZero: true] : [Constants.UserInfo.isIndexZero: false]
            NotificationCenter.default.post(name: .dateIndexDidChange, object: nil, userInfo: info)
        }
    }
    
    var selectedDate: Date {
        return dates[currentIndex]
    }
    
    init() {
        self.dates = Date().datesInFuture(after: 14)
    }
    
    func decreaseDate() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    func increaseDate() {
        guard let lastIndex = dates.indices.last else { fatalError("Date array is empty!") }
        
        if currentIndex != lastIndex {
            currentIndex += 1
        }
    }
}

extension Date {
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
