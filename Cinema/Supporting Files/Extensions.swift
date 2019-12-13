//
//  Extensions.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    /// Returns an array without duplicates.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension Date {
    enum StringFormat {
        case fullDate
        case excludeTime
        case onlyTime
        case monthNameAndDay
    }
    
    /// Converts Date to String.
    func asString(format: StringFormat = .fullDate) -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "lt")
        
        switch format {
        case .fullDate:
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        case .excludeTime:
            formatter.dateFormat = "yyyy-MM-dd"
        case .onlyTime:
            formatter.dateFormat = "HH:mm"
        case .monthNameAndDay:
            formatter.dateFormat = "MMMM d"
        }
        
        return formatter.string(from: self)
    }
    
    func isInThePast() -> Bool {
        return self < Date()
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

extension UserDefaults {
    /// Returns a Boolean value indicating whether value for key "city" exists.
    /// If the value does not exist, function saves a default value before returning false.
    /// Only used to check if the app is started for the first time.
    func isCitySet() -> Bool {
        if let _ = UserDefaults.standard.string(forKey: "city") {
            return true
        } else {
            save(city: City.vilnius)
            return false
        }
    }
    
    func save(city: City) {
        UserDefaults.standard.set(city.rawValue, forKey: "city")
    }
    
    func readCity() -> City {
        if let value = UserDefaults.standard.string(forKey: "city"), let city = City(rawValue: value) {
            return city
        } else {
            return City.vilnius
        }
    }
}
