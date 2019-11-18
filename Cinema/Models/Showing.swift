//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

class Showing: Decodable {
    let city: String
    let date: Date
    let venue: String
    var parentMovie: Movie?
    
    init(city: String, date: Date, venue: String, parentMovie: Movie) {
        self.city = city
        self.date = date
        self.venue = venue
        self.parentMovie = parentMovie
    }
}
