//
//  Extensions.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension Array where Element: Hashable {
    /// Returns an array without duplicates.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension CGFloat {
    static func dynamicFontSize(_ fontSize: CGFloat) -> CGFloat {
        /// 
        let calculatedFontSize = .screenWidth / 320 * fontSize
        return calculatedFontSize
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

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)
        
        return self
    }
}

///
extension UIColor {
    func image(size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    func addBottomBorder(with color: UIColor?, width borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
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
