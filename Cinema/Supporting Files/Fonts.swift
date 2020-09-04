//
//  Fonts.swift
//  Cinema
//
//  Created by Marius on 2020-09-04.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

enum Fonts: String {
    case notFound

    private var font: UIFont {
        switch self {
        default:
            return UIFont.init(name: "BodoniOrnamentsITCTT", size: 50)!
        }
    }

    static func getFont(rawValue: String) -> UIFont  {
        if let fonts = Fonts(rawValue: rawValue) {
            return fonts.font
        }

        return Fonts.notFound.font
    }
}
