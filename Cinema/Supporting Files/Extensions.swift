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
    
    enum asStringFormat {
        case fullDate
        case excludeTime
        case onlyTime
        case monthNameAndDay
    }
    
    /// Converts Date to String.
    func asString(format: asStringFormat = .fullDate) -> String {
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
    func save(city: City) {
        UserDefaults.standard.set(city.rawValue, forKey: "city")
    }
    
    func readCity() -> City? {
        guard let city = UserDefaults.standard.string(forKey: "city") else { return nil }
        return City(rawValue: city)
    }
}
