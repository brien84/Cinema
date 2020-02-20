//
//  MovieManagerTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieManagerTests: XCTestCase {

    var sut: MovieManager!

    override func setUp() {
        sut = MovieManager()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: MovieFetchable

    func testFetchingCompletesSuccessfully() {
        // given
        let session = TestHelper.makeMockURLSession(with: TestHelper.generateMovieData())
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        sut.fetch(using: session) { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
    }

    func testFetchingFailsToCompleteWhenDataIsUndecodable() {
        // given
        let session = TestHelper.makeMockURLSession(with: Data())
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        sut.fetch(using: session) { result in
            switch result {
            case .success:
                XCTFail("Decoding error should be present!")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
    }

    func testFetchingFailsToCompleteWhenNetworkIsNotAvailable() {
        // given
        let session = TestHelper.makeMockURLSession(with: nil)
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        sut.fetch(using: session) { result in
            switch result {
            case .success:
                XCTFail("No network error should be present!")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
    }

    // MARK: MovieFilterable

    func testFilterMovies() {
        // given
        let requiredMovieCount = 6
        let requiredCity = City.vilnius
        let requiredDate = TestHelper.generateDateDaysFromNow(1)

        let requiredMovies = TestHelper.generateMovies(movieCount: requiredMovieCount, city: requiredCity, date: requiredDate)

        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = mapMovies(in: decoyCities, at: decoyDates) { city, date in
            [
             TestHelper.generateMovies(movieCount: 5, city: city, date: date),
             TestHelper.generateMovies(movieCount: 6, city: requiredCity, date: date),
             TestHelper.generateMovies(movieCount: 7, city: city, date: requiredDate)
            ].flatMap { $0 }
        }

        // when
        sut.movies.append(contentsOf: requiredMovies)
        sut.movies.append(contentsOf: decoyMovies)

        // then
        let movieCount = sut.filterMovies(in: requiredCity, at: requiredDate).count

        XCTAssertEqual(movieCount, requiredMovieCount)
    }

    func testFilterMoviesReturnZero() {
        // given
        let requiredCity = City.vilnius
        let requiredDate = TestHelper.generateDateDaysFromNow(1)

        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = mapMovies(in: decoyCities, at: decoyDates) { city, date in
            [
             TestHelper.generateMovies(movieCount: 5, city: city, date: date),
             TestHelper.generateMovies(movieCount: 6, city: requiredCity, date: date),
             TestHelper.generateMovies(movieCount: 7, city: city, date: requiredDate)
            ].flatMap { $0 }
        }

        // when
        sut.movies.append(contentsOf: decoyMovies)

        // then
        let movieCount = sut.filterMovies(in: requiredCity, at: requiredDate).count

        XCTAssertEqual(movieCount, 0)
    }

    func testFilterShowings() {
        // given
        let moviesCount = 4
        let showingsPerMovieCount = 6
        let requiredShowingsCount = moviesCount * showingsPerMovieCount
        let requiredCity = City.vilnius
        let requiredDate = TestHelper.generateDateDaysFromNow(1)

        let requiredMovies = TestHelper.generateMovies(movieCount: moviesCount, showingsPerMovie: showingsPerMovieCount, city: requiredCity, date: requiredDate)

        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = mapMovies(in: decoyCities, at: decoyDates) { city, date in
            [
             TestHelper.generateMovies(showingsPerMovie: 1, city: city, date: date),
             TestHelper.generateMovies(showingsPerMovie: 2, city: requiredCity, date: date),
             TestHelper.generateMovies(showingsPerMovie: 3, city: city, date: requiredDate)
            ].flatMap { $0 }
        }

        // when
        sut.movies.append(contentsOf: requiredMovies)
        sut.movies.append(contentsOf: decoyMovies)

        // then
        let showingsCount = sut.filterShowings(in: requiredCity, at: requiredDate).count

        XCTAssertEqual(showingsCount, requiredShowingsCount)
    }

    func testGetShowingsReturnZero() {
        // given
        let requiredCity = City.vilnius
        let requiredDate = TestHelper.generateDateDaysFromNow(1)

        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = mapMovies(in: decoyCities, at: decoyDates) { city, date in
            [
             TestHelper.generateMovies(showingsPerMovie: 1, city: city, date: date),
             TestHelper.generateMovies(showingsPerMovie: 2, city: requiredCity, date: date),
             TestHelper.generateMovies(showingsPerMovie: 3, city: city, date: requiredDate)
            ].flatMap { $0 }
        }

        // when
        sut.movies.append(contentsOf: decoyMovies)

        // then
        let showingsCount = sut.filterShowings(in: requiredCity, at: requiredDate).count

        XCTAssertEqual(showingsCount, 0)
    }

    // MARK: TestHelper:

    private func mapMovies(in cities: [City], at dates: [Date], movies: (_: City, _: Date) -> [Movie]) -> [Movie] {
        return cities.flatMap { city in
            dates.flatMap { date in
                movies(city, date)
            }
        }
    }

}
