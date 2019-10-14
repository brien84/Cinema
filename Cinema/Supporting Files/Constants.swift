//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

// TODO: CASES TO LOWERCASE
enum DailyVCSegments: Int, CaseIterable {
    case Filmai
    case Seansai
}

enum MovieVCSegments: Int, CaseIterable {
    case Apie
    case Seansai
}

enum City: String, CaseIterable {
    case vilnius = "Vilnius"
    case kaunas = "Kaunas"
    case klaipeda = "Klaipėda"
    case siauliai = "Šiauliai"
}
