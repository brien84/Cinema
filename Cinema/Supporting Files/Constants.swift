//
//  Constants.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

enum DailyVCSegments: Int, CaseIterable {
    case filmai
    case seansai
}

enum MovieVCSegments: Int, CaseIterable {
    case apie
    case seansai
}

enum City: String, CaseIterable {
    case vilnius = "Vilnius"
    case kaunas = "Kaunas"
    case klaipeda = "Klaipėda"
    case siauliai = "Šiauliai"
}
