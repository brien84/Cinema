//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

final class Showing: Codable {
    let city: String
    let date: Date
    let venue: String
    let is3D: Bool
    var parentMovie: Movie?

    init(city: String, date: Date, venue: String, is3D: Bool, parentMovie: Movie?) {
        self.city = city
        self.date = date
        self.venue = venue
        self.is3D = is3D
        self.parentMovie = parentMovie
    }

    private enum CodingKeys: String, CodingKey {
        case city
        case date
        case venue
        case is3D
    }
}

extension Showing {
    func isShown(in city: City) -> Bool {
        if self.date.isInThePast() { return false }

        return self.city == city.rawValue
    }

    func isShown(at date: Date) -> Bool {
        if self.date.isInThePast() { return false }

        let calendar = Calendar.current
        return calendar.isDate(self.date, inSameDayAs: date)
    }
}
