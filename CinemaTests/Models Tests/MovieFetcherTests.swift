//
//  MovieFetcherTests.swift
//  CinemaTests
//
//  Created by Marius on 2020-11-15.
//  Copyright © 2020 Marius. All rights reserved.
//

// swiftlint:disable force_try
import XCTest
@testable import iKinas

final class MovieFetcherTests: XCTestCase {
    var sut: MovieFetcher!

    override func setUp() {
        sut = MovieFetcher()
    }

    override func tearDown() {
        sut = nil
    }

    func testFetchingSuccessReturnsMovies() {
        let city = City.vilnius
        let date = Date(timeIntervalSince1970: 0)
        let venue = "testVenue"
        let is3D = true
        let showing = Showing.create(city, date, venue, is3D)

        let title = "testTitle"
        let originalTitle = "testOriginalTitle"
        let year = "testYear"
        let ageRating = "testAgeRating"
        let duration = "testDuration"
        let genres = ["test", "genres"]
        let plot = "testPlot"
        let poster = URL(string: "https://test.url")!
        let movie = Movie.create(title, originalTitle, year, ageRating, duration, genres, plot, poster, [showing])

        let session = URLSession.makeMockSession(with: [movie].encoded())

        let expectation = self.expectation(description: "Wait for fetching to end.")

        sut.fetchMovies(in: city, using: session) { result in
            let movies = try! result.get()

            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies[0].title, title)
            XCTAssertEqual(movies[0].originalTitle, originalTitle)
            XCTAssertEqual(movies[0].year, year)
            XCTAssertEqual(movies[0].ageRating, ageRating)
            XCTAssertEqual(movies[0].duration, duration)
            XCTAssertEqual(movies[0].genres, genres)
            XCTAssertEqual(movies[0].plot, plot)
            XCTAssertEqual(movies[0].poster, poster)

            XCTAssertEqual(movies[0].showings.count, 1)
            XCTAssertEqual(movies[0].showings[0].city, city)
            XCTAssertEqual(movies[0].showings[0].date, date)
            XCTAssertEqual(movies[0].showings[0].venue, venue)
            XCTAssertEqual(movies[0].showings[0].is3D, is3D)
            XCTAssertEqual(movies[0].showings[0].parentMovie, movies[0])

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testFetchingFailureWhenDataCouldNotBeDecoded() {
        let session = URLSession.makeMockSession(with: Data())

        let expectation = self.expectation(description: "Wait for fetching to end.")

        sut.fetchMovies(in: .vilnius, using: session) { result in
            switch result {
            case .success:
                XCTFail("Fetching should fail!")
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error as? DecodingError)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testFetchingFailureWhenNotConnectedToInternet() {
        let session = URLSession.makeMockSession(with: nil)

        let expectation = self.expectation(description: "Wait for fetching to end.")

        sut.fetchMovies(in: .vilnius, using: session) { result in
            switch result {
            case .success:
                XCTFail("Fetching should fail!")
            case .failure(let error):
                XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
