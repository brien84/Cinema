//
//  Movie.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

class Movie: Decodable {
    let title: String
    let originalTitle: String?
    let duration: String?
    let ageRating: String?
    let genre: String?
    let country: String?
    let releaseDate: String?
    let poster: String?
    let plot: String?
    let showings: [Showing]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case originalTitle
        case duration
        case ageRating
        case genre
        case country
        case releaseDate
        case poster
        case plot
        case showings
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        originalTitle = try? values.decode(String.self, forKey: .originalTitle)
        duration = try? values.decode(String.self, forKey: .duration)
        ageRating = try? values.decode(String.self, forKey: .ageRating)
        genre = try? values.decode(String.self, forKey: .genre)
        country = try? values.decode(String.self, forKey: .country)
        releaseDate = try? values.decode(String.self, forKey: .releaseDate)
        poster = try? values.decode(String.self, forKey: .poster)
        plot = try? values.decode(String.self, forKey: .plot)
        
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
