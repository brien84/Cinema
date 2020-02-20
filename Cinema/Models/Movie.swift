//
//  Movie.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

final class Movie: Codable {

    let title: String
    let originalTitle: String
    let year: String
    let ageRating: String?
    let duration: String?
    let genres: [String]?
    let plot: String?
    let poster: URL?
    var showings: [Showing]

    private enum CodingKeys: String, CodingKey {
        case title
        case originalTitle
        case year
        case ageRating
        case duration
        case genres
        case plot
        case poster
        case showings
    }

    init(title: String, originalTitle: String, year: String, ageRating: String?,
         duration: String?, genres: [String]?, plot: String?, poster: URL?, showings: [Showing]) {
        self.title = title
        self.originalTitle = originalTitle
        self.year = year
        self.ageRating = ageRating
        self.duration = duration
        self.genres = genres
        self.plot = plot
        self.poster = poster
        self.showings = showings
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decode(String.self, forKey: .title)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        year = try values.decode(String.self, forKey: .year)
        ageRating = try? values.decode(String.self, forKey: .ageRating)
        duration = try? values.decode(String.self, forKey: .duration)
        genres = try? values.decode([String].self, forKey: .genres)
        plot = try? values.decode(String.self, forKey: .plot)
        poster = try? values.decode(URL.self, forKey: .poster)

        showings = try values.decode([Showing].self, forKey: .showings)

        showings.forEach { showing in
            showing.parentMovie = self
        }
    }
}

extension Movie {
    func getShowings(in city: City) -> [Showing] {
        return self.showings.filter { $0.isShown(in: city) }
    }

    func getShowings(in city: City, at date: Date) -> [Showing] {
        return self.showings.filter { $0.isShown(in: city) && $0.isShown(at: date) }
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
