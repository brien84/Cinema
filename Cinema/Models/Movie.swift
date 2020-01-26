//
//  Movie.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

final class Movie: Decodable {
    let title: String
    let originalTitle: String
    let year: String
    let ageRating: String?
    let duration: String?
    let genre: [String]?
    let plot: String?
    let poster: URL?
    var showings: [Showing]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case originalTitle
        case year
        case ageRating
        case duration
        case genre
        case plot
        case poster
        case showings
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        year = try values.decode(String.self, forKey: .year)
        ageRating = try? values.decode(String.self, forKey: .ageRating)
        duration = try? values.decode(String.self, forKey: .duration)
        genre = try? values.decode([String].self, forKey: .genre)
        plot = try? values.decode(String.self, forKey: .plot)
        poster = try? values.decode(URL.self, forKey: .poster)

        showings = try values.decode([Showing].self, forKey: .showings)
        
        showings.forEach { showing in
            showing.parentMovie = self
        }
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
