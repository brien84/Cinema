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

extension UIColor {
    static let darkC = UIColor(named: "dark")!
    static let grayC = UIColor(named: "gray")!
    static let lightC = UIColor(named: "light")!
    static let redC = UIColor(named: "red")!
    static let transparentBlackC = UIColor(named: "transparentBlack")!
}

extension URL {
    static let api = URL(string: "https://movies.ioys.lt/all")!
    //static let api = URL(string: "http://localhost:8080/all")!
}
