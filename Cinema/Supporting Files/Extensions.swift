//
//  Extensions.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension CGFloat {
    /// Scales `UIFont` size according to screen width.
    /// On devices with 320 points screen width returned value will be same as
    /// `fontSize` argument and will scale upwards in size on wider screens.
    static func dynamicFontSize(_ fontSize: CGFloat) -> CGFloat {
        let calculatedFontSize = .screenWidth / 320 * fontSize
        return calculatedFontSize
    }
}

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

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)

        return self
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

extension UIView {
    enum AnimationDirection {
        case left
        case right
    }

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
