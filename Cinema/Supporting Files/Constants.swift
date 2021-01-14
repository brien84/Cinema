//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

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

extension TimeInterval {
    static let stdAnimation = 0.4
}

extension UIColor {
    static let primaryElement = UIColor(named: "primaryElement")!
    static let secondaryElement = UIColor(named: "secondaryElement")!
    static let tertiaryElement = UIColor(named: "tertiaryElement")!
    static let primaryBackground = UIColor(named: "primaryBackground")!
    static let secondaryBackground = UIColor(named: "secondaryBackground")!
}

extension UIImage {
    static let arrowLeft = UIImage(named: "arrowLeft")!
    static let arrowRight = UIImage(named: "arrowRight")!
    static let settings = UIImage(named: "settings")!
    static let navTicket = UIImage(named: "navTicket")
}

extension URL {
    static let api = URL(string: "https://movies.ioys.lt/")!
    //static let api = URL(string: "http://localhost:8080/")!
}
