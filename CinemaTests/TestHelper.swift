//
//  TestMethods.swift
//  CinemaTests
//
//  Created by Marius on 2020-02-16.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

struct TestHelper {

    static func loadTestData() -> Data {
        guard let asset = NSDataAsset(name: "testData") else {
            fatalError("testData file is not found!")
        }

        return asset.data
    }

    static func decodeMovies(from data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([Movie].self, from: data)
    }

    static func getMovie() -> Movie {
        let data = TestHelper.loadTestData()

        guard let movies = try? TestHelper.decodeMovies(from: data) else {
            fatalError("could not decode movies!")
        }

        guard let movie = movies.first else {
            fatalError("movies array is empty!")
        }

        return movie
    }

}
