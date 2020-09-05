//
//  Fonts.swift
//  Cinema
//
//  Created by Marius on 2020-09-04.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

enum Fonts: String {
    case dateViewHeader, dateViewTitle, dateViewOriginalTitle, dateViewDetails
    case notFound

    private var font: UIFont {
        switch self {
        case .dateViewHeader:
            return UIFont.init(name: "HelveticaNeue-Bold", size: 20)!
        case .dateViewTitle:
            return UIFont.init(name: "HelveticaNeue-Medium", size: 18)!
        case .dateViewOriginalTitle:
            return UIFont.init(name: "HelveticaNeue-LightItalic", size: 15)!
        case .dateViewDetails:
            return UIFont.init(name: "HelveticaNeue-Thin", size: 15)!
        default:
            return UIFont.init(name: "BodoniOrnamentsITCTT", size: 50)!
        }
    }

    static func getFont(_ identifier: String) -> UIFont {
        if let fonts = Fonts(rawValue: identifier) {
            return fonts.font
        }

        return Fonts.notFound.font
    }
}
