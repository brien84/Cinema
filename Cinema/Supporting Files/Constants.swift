//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

extension TimeInterval {
    static let stdAnimation = 0.4
}

extension UIImage {
    static let options = UIImage(named: "options")!
    static let arrowLeft = UIImage(named: "arrowLeft")!
    static let arrowRight = UIImage(named: "arrowRight")!
}

extension UIColor {
    static let darkC = UIColor(named: "dark")!
    static let grayC = UIColor(named: "gray")!
    static let lightC = UIColor(named: "light")!
    static let redC = UIColor(named: "red")!
    static let transparentBlackC = UIColor(named: "transparentBlack")!

    static let primaryElement = UIColor(named: "primaryElement")!
    static let secondaryElement = UIColor(named: "secondaryElement")!
    static let tertiaryElement = UIColor(named: "tertiaryElement")!
    static let primaryBackground = UIColor(named: "primaryBackground")!
    static let secondaryBackground = UIColor(named: "secondaryBackground")!
}

extension URL {
    static let api = URL(string: "https://movies.ioys.lt/")!
    //static let api = URL(string: "http://localhost:8080/")!
}

extension City {
    var api: URL {
        switch self {
        case .vilnius:
            return URL.api.appendingPathComponent("vilnius")
        case .kaunas:
            return URL.api.appendingPathComponent("kaunas")
        case .klaipeda:
            return URL.api.appendingPathComponent("klaipeda")
        case .siauliai:
            return URL.api.appendingPathComponent("siauliai")
        }
    }
}
