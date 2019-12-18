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
        static let lightBlue = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.50)     //#70a1ff
        static let light = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)         //#ffffff
        static let gray = UIColor(red: 87/255, green: 86/255, blue: 111/255, alpha: 1.0)            //#57606f
        static let dark = UIColor(red: 47/255, green: 53/255, blue: 66/255, alpha: 1.0)             //#2f3542
    }
    
    struct Fonts {
        struct DateContainerCell {
            static let title = UIFont(name: "HelveticaNeue-Medium", size: 22.0)!
            static let originalTitle = UIFont(name: "HelveticaNeue-ThinItalic", size: 16.0)!
            static let label = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        }
        
        struct MovieShowingCell {
            static let time = UIFont(name: "HelveticaNeue-Medium", size: 36.0)!
            static let date = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
            static let venue = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        }
        
        struct MovieView {
            static let staticLabel = UIFont(name: "HelveticaNeue-Thin", size: 14.0)!
            static let dynamicLabel = UIFont(name: "HelveticaNeue-Light", size: 17.0)!
            static let plot = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        }
        
        static let errorLabel = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        static let optionsCell = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
    }
    
    struct Images {
        static let options = UIImage(named: "options")!
        static let left = UIImage(named: "arrowLeft")!
        static let right = UIImage(named: "arrowRight")!
    }
    
    struct URLs {
        static let api = URL(string: "https://movies.ioys.lt/all")!
        //static let api = URL(string: "http://localhost:8080/all")!
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
