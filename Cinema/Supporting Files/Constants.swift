//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

struct Colors {
    static let dark = UIColor(named: "dark")!
    static let gray = UIColor(named: "gray")!
    static let light = UIColor(named: "light")!
    static let red = UIColor(named: "red")!
    static let transparentBlack = UIColor(named: "transparentBlack")!
}

struct Constants {
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
}
