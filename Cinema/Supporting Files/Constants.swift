//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

struct Constants {
    struct URLs {
        static let api = URL(string: "http://localhost:8080/movies")!
    }
    
    struct Images {
        static let options = UIImage(named: "options")!
        static let left = UIImage(named: "arrowLeft")!
        static let right = UIImage(named: "arrowRight")!
    }
    
    struct UserInfo {
        static let isIndexZero = "isIndexZero"
    }
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

enum City: String, CaseIterable {
    case vilnius = "Vilnius"
    case kaunas = "Kaunas"
    case klaipeda = "Klaipėda"
    case siauliai = "Šiauliai"
}
