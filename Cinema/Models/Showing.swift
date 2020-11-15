//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

struct Showing: Codable {
    let city: City
    let date: Date
    let venue: String
    let is3D: Bool
    var parentMovie: Movie?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        city = try values.decode(City.self, forKey: .city)
        date = try values.decode(Date.self, forKey: .date)
        venue = try values.decode(String.self, forKey: .venue)
        is3D = try values.decode(Bool.self, forKey: .is3D)
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

        return self.city == city
    }

    func isShown(at date: Date) -> Bool {
        if self.date.isInThePast() { return false }

        let calendar = Calendar.current
        return calendar.isDate(self.date, inSameDayAs: date)
    }
}
