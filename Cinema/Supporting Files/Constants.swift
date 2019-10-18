//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

struct Constants {
    struct Colors {
        static let blue = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0)           //#1e90ff
        static let lightBlue = UIColor(red: 112/255, green: 161/255, blue: 255/255, alpha: 1.0)     //#70a1ff
        static let light = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)         //#ffffff
        static let lightGray = UIColor(red: 241/255, green: 242/255, blue: 246/255, alpha: 1.0)     //#f1f2f6
        static let darkGray = UIColor(red: 87/255, green: 86/255, blue: 111/255, alpha: 1.0)        //#57606f
        static let dark = UIColor(red: 47/255, green: 53/255, blue: 66/255, alpha: 1.0)             //#2f3542
    }
    
    struct Images {
        static let options = UIImage(named: "options")!
        static let left = UIImage(named: "arrowLeft")!
        static let right = UIImage(named: "arrowRight")!
    }
    
    struct URLs {
        static let api = URL(string: "http://localhost:8080/movies")!
    }

    struct UserInfo {
        static let isIndexZero = "isIndexZero"
    }
}

enum City: String, CaseIterable {
    case vilnius = "Vilnius"
    case kaunas = "Kaunas"
    case klaipeda = "Klaipėda"
    case siauliai = "Šiauliai"
}

enum DateContainerSegments: Int, CaseIterable, CustomStringConvertible {
    case movies
    case showings
    
    public var description: String {
        switch self {
        case .movies:
            return "Filmai"
        case .showings:
            return "Seansai"
        }
    }
}

enum MovieContainerSegments: Int, CaseIterable, CustomStringConvertible {
    case about
    case showings
    
    public var description: String {
        switch self {
        case .about:
            return "Apie"
        case .showings:
            return "Seansai"
        }
    }
}
