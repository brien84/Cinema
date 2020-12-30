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
            return UIFont.init(name: "HelveticaNeue-Bold", size: 30)!
        case .dateViewTitle, .dateContainerViewTitle:
            return UIFont.init(name: "HelveticaNeue-Medium", size: 17)!
        case .dateViewOriginalTitle:
            return UIFont.init(name: "HelveticaNeue-Italic", size: 15)!
        case .dateViewDetails:
            return UIFont.init(name: "HelveticaNeue", size: 14)!
        case .loadingViewError:
            return UIFont.init(name: "HelveticaNeue-Medium", size: 25)!
        case .navigationBar:
            return UIFont.init(name: "HelveticaNeue-Medium", size: 17)!
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
