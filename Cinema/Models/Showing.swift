//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

final class Showing: Codable {
    let city: City
    let date: Date
    let venue: String
    let is3D: Bool
    weak var parentMovie: Movie?

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
