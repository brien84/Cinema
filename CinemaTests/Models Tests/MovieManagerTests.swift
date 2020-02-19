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
        let session = TestHelper.makeMockURLSession(with: TestHelper.loadTestData())
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

        let decoyMovies = decoyCities.flatMap { city in

                decoyDates.flatMap { date -> [Movie] in
                    var movies = [Movie]()
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 8, city: city, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 3, city: requiredCity, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 6, city: city, date: requiredDate))

                    return movies
                }
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

        let decoyMovies = decoyCities.flatMap { city in

                decoyDates.flatMap { date -> [Movie] in
                    var movies = [Movie]()
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 8, city: city, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 3, city: requiredCity, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 6, city: city, date: requiredDate))

                    return movies
                }
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

        //
        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = decoyCities.flatMap { city in

                decoyDates.flatMap { date -> [Movie] in
                    var movies = [Movie]()
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 8, city: city, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 3, city: requiredCity, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 6, city: city, date: requiredDate))

                    return movies
                }
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

        //
        let decoyCities = [City.kaunas, City.klaipeda, City.siauliai]
        let decoyDates = [TestHelper.generateDateDaysFromNow(2), TestHelper.generateDateDaysFromNow(3)]

        let decoyMovies = decoyCities.flatMap { city in

                decoyDates.flatMap { date -> [Movie] in
                    var movies = [Movie]()
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 8, city: city, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 3, city: requiredCity, date: date))
                    movies.append(contentsOf: TestHelper.generateMovies(movieCount: 6, city: city, date: requiredDate))

                    return movies
                }
        }

        // when
        sut.movies.append(contentsOf: decoyMovies)

        // then
        let showingsCount = sut.filterShowings(in: requiredCity, at: requiredDate).count

        XCTAssertEqual(showingsCount, 0)
    }

}
