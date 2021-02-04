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
    case dateContainerViewTitle
    case loadingViewError
    case movieViewTitle, movieViewOriginalTitle, movieViewDetail
    case navigationBar
    case settingsViewCity, settingsViewHeader
    case showingsViewDate, showingsViewTime, showingsViewVenue
    case notFound

    private var font: UIFont {
        switch self {
        case .dateViewHeader:
            return UIFont(name: "HelveticaNeue-Bold", size: 30)!
        case .dateViewTitle, .dateContainerViewTitle:
            return UIFont(name: "HelveticaNeue-Medium", size: 17)!
        case .dateViewOriginalTitle:
            return UIFont(name: "HelveticaNeue-Italic", size: 15)!
        case .dateViewDetails:
            return UIFont(name: "HelveticaNeue", size: 14)!
        case .loadingViewError:
            return UIFont(name: "HelveticaNeue", size: 24)!
        case .movieViewTitle:
            return UIFont(name: "HelveticaNeue-Medium", size: 28)!
        case .movieViewOriginalTitle:
            return UIFont(name: "HelveticaNeue-Light", size: 16)!
        case .movieViewDetail:
            return UIFont(name: "HelveticaNeue", size: 16)!
        case .navigationBar:
            return UIFont(name: "HelveticaNeue-Medium", size: 17)!
        case .showingsViewDate:
            return UIFont(name: "HelveticaNeue-Medium", size: 17)!
        case .showingsViewTime:
            return UIFont(name: "HelveticaNeue", size: 28)!
        case .showingsViewVenue:
            return UIFont(name: "HelveticaNeue", size: 20)!
        case .settingsViewCity:
            return UIFont(name: "HelveticaNeue-Light", size: 23)!
        case .settingsViewHeader:
            return UIFont(name: "HelveticaNeue-Bold", size: 28)!
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
