//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

final class Showing: Decodable {
    let city: String
    let date: Date
    let venue: String
    let is3D: Bool
    var parentMovie: Movie?
    
    init(city: String, date: Date, venue: String, is3D: Bool, parentMovie: Movie) {
        self.city = city
        self.date = date
        self.venue = venue
        self.is3D = is3D
        self.parentMovie = parentMovie
    }
}
