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
    
    private var currentIndex = 0
    
    var selectedDate: Date {
        return dates[currentIndex]
    }
    
    init() {
        self.dates = Date().datesInFuture(after: 14, of: .day)
    }
    
    func decreaseDate() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    func increaseDate() {
        if currentIndex < (dates.count - 1) {
            currentIndex += 1
        }
    }
}
