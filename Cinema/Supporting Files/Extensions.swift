//
//  Extensions.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

extension Date {
    enum asStringFormat {
        case fullDate
        case excludeTime
        case onlyTime
    }
    
    func asString(format: asStringFormat = .fullDate) -> String {
        let formatter = DateFormatter()
        
        switch format {
        case .fullDate:
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        case .excludeTime:
            formatter.dateFormat = "yyyy-MM-dd"
        case .onlyTime:
            formatter.dateFormat = "HH:mm"
        }
        
        return formatter.string(from: self)
    }
    
    func datesInFuture(after amount: Int, of component: Calendar.Component) -> [Date] {
        var date = self
        guard let endDate = Calendar.current.date(byAdding: component, value: amount, to: date) else { return [] }
        var dates = [Date]()
        
        while date <= endDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: component, value: 1, to: date) else { return [] }
            date = newDate
        }
        
        return dates
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

extension Notification.Name {
    // TODO: Rename to be more clear
    static let didFinishFetching = Notification.Name("didFinishFetching")
    static let dateIndexDidChange = Notification.Name("dateIndexDidChange")
    static let cityDidChange = Notification.Name("cityDidChange")
}

extension UserDefaults {
    func save(city: City) {
        UserDefaults.standard.set(city.rawValue, forKey: "city")
    }
    
    func readCity() -> City? {
        guard let city = UserDefaults.standard.string(forKey: "city") else { return nil }
        return City(rawValue: city)
    }
}
