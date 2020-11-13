//
//  TestHelper.swift
//  CinemaTests
//
//  Created by Marius on 2020-02-16.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

struct TestHelper {

    static func generateMovie(with titleIndex: Int = 0) -> Movie {
        return Movie(title: "someTitle\(titleIndex)",
                     originalTitle: "someOriginalTitle",
                     year: "someYear",
                     ageRating: "someAgeRating",
                     duration: "someDuration",
                     genres: ["someGenre"],
                     plot: "somePlot",
                     poster: URL(string: "https://www.someUrl.com"),
                     showings: [])
    }

    static func generateShowing(in city: City, at date: Date, parentMovie: Movie? = nil) -> Showing {
        return Showing(city: city,
                       date: date,
                       venue: "someVenue",
                       is3D: false,
                       parentMovie: parentMovie)
    }

    static func generateMovies(movieCount: Int = 1, showingsPerMovie: Int = 1, city: City = .vilnius, date: Date = Date()) -> [Movie] {
        var movies = [Movie]()

        guard movieCount > 0 else { return movies }

        for index in 1...movieCount {
            let newMovie = generateMovie(with: index)
            movies.append(newMovie)

            guard showingsPerMovie > 0 else { continue }

            for _ in 1...showingsPerMovie {
                let showing = generateShowing(in: city, at: date, parentMovie: newMovie)
                newMovie.showings.append(showing)
            }
        }

        return movies
    }

    static func generateMovieData() -> Data {
        let movies = TestHelper.generateMovies()

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(movies) else {
            fatalError("Could not encode movies!")
        }

        return data
    }

    static func decodeMovies(from data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([Movie].self, from: data)
    }

    static func generateDateDaysFromNow(_ days: Double) -> Date {
        return Date(timeIntervalSinceNow: 86400 * days)
    }
}
