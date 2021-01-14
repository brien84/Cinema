//
//  Extensions.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension Date {
    enum StringFormat {
        case dateAndTime
        case monthAndDay
        case timeOfDay
    }

    /// Converts `Date` to `String`.
    func asString(_ format: StringFormat = .dateAndTime) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "lt")

        switch format {
        case .dateAndTime:
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        case .monthAndDay:
            if Calendar.current.isDateInToday(self) { return "Šiandien" }
            if Calendar.current.isDateInTomorrow(self) { return "Rytoj" }
            formatter.dateFormat = "MMMM d"
        case .timeOfDay:
            formatter.dateFormat = "HH:mm"
        }

        return formatter.string(from: self)
    }
}

extension UIColor {
    /// Creates `UIImage` filled with `UIColor`.
    func image(size: CGSize, isEclipse: Bool = false) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            let rect = CGRect(origin: .zero, size: size)
            self.setFill()

            if isEclipse {
                rendererContext.cgContext.fillEllipse(in: rect)
            } else {
                rendererContext.fill(rect)
            }
        }
    }
}

extension UINavigationBar {
    func setBackgroundImage(color: UIColor, alpha: CGFloat = 1.0) {
        // If `alpha` is equal or higher than 1.0 `UINavigationBar`
        // will apply a system-defined alpha.
        let alpha = alpha >= 1.0 ? 0.99 : alpha
        let color = color.withAlphaComponent(alpha)
        // `UINavigationBar` will size the image to fill.
        let image = color.image(size: CGSize(width: 1, height: 1))
        self.setBackgroundImage(image, for: .default)
    }
}

extension UserDefaults {
    /// Returns a Boolean value indicating whether value for key "city" exists.
    /// If the value does not exist, function saves a default value before returning false.
    /// Only used to check if the app is started for the first time.
    func isCitySet() -> Bool {
        if UserDefaults.standard.string(forKey: "city") != nil {
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
