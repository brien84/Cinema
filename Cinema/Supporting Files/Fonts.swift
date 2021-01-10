//
//  Fonts.swift
//  Cinema
//
//  Created by Marius on 2020-09-04.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

enum Fonts: String {
    case dateViewHeaderLabel, dateViewTitle, dateViewOriginalTitle, dateViewDetails
    case dateContainerViewTitle
    case loadingViewError
    case navigationBar
    case notFound

    private var font: UIFont {
        switch self {
        case .dateViewHeaderLabel:
            return UIFont(name: "HelveticaNeue-Bold", size: 30)!
        case .dateViewTitle, .dateContainerViewTitle:
            return UIFont(name: "HelveticaNeue-Medium", size: 17)!
        case .dateViewOriginalTitle:
            return UIFont(name: "HelveticaNeue-Italic", size: 15)!
        case .dateViewDetails:
            return UIFont(name: "HelveticaNeue", size: 14)!
        case .loadingViewError:
            return UIFont(name: "HelveticaNeue-Medium", size: 25)!
        case .navigationBar:
            return UIFont(name: "HelveticaNeue-Medium", size: 17)!
        default:
            return UIFont(name: "BodoniOrnamentsITCTT", size: 50)!
        }
    }

    static func getFont(_ font: Fonts) -> UIFont {
        font.font
    }

    static func getFont(_ identifier: String) -> UIFont {
        if let fonts = Fonts(rawValue: identifier) {
            return fonts.font
        }

        return Fonts.notFound.font
    }
}
