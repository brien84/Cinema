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

    func testFetchingReturnsSuccessfulResult() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading movies.")
        
        let session = makeMockURLSession(with: TestData.correctData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchingReturnsFailureResultWithBadData() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading movies.")
        
        let session = makeMockURLSession(with: TestData.badData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchingReturnsFailureResultWithNoData() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading movies.")
        
        let session = makeMockURLSession(with: TestData.noData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetMoviesReturnsCorrectNumberOfMoviesWhenCitiesAndDatesAreDifferent() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 5, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedCity = City.kaunas
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 7, city: unwantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let moviesCount = sut.filterMovies(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(moviesCount, 5)
    }
    
    func testGetMoviesReturnsCorrectNumberOfMoviesWhenCitiesAreSameAndDatesAreDifferent() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 8, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 4, city: wantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let moviesCount = sut.filterMovies(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(moviesCount, 8)
    }
    
    func testGetMoviesReturnsCorrectNumberOfMoviesWhenCitiesAreDifferentAndDatesAreSame() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 2, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedCity = City.kaunas
        let unwantedMovies = createMovies(count: 4, city: unwantedCity, date: wantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let moviesCount = sut.filterMovies(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(moviesCount, 2)
    }
    
    func testGetMoviesReturnsZero() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        
        let unwantedCity = City.kaunas
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 4, city: unwantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let moviesCount = sut.filterMovies(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(moviesCount, 0)
    }
    
    func testGetShowingssReturnsCorrectNumberOfMoviesWhenCitiesAndDatesAreDifferent() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 5, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedCity = City.kaunas
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 7, city: unwantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let showingsCount = sut.filterShowings(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(showingsCount, 5)
    }
    
    func testGetShowingsReturnsCorrectNumberOfMoviesWhenCitiesAreSameAndDatesAreDifferent() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 8, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 4, city: wantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let showingsCount = sut.filterShowings(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(showingsCount, 8)
    }
    
    func testGetShowingsReturnsCorrectNumberOfMoviesWhenCitiesAreDifferentAndDatesAreSame() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        let wantedMovies = createMovies(count: 2, city: wantedCity, date: wantedDate)
        sut.movies.append(contentsOf: wantedMovies)
        
        let unwantedCity = City.kaunas
        let unwantedMovies = createMovies(count: 4, city: unwantedCity, date: wantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let showingsCount = sut.filterShowings(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(showingsCount, 2)
    }
    
    func testGetShowingsReturnsZero() {
        /// given
        let wantedCity = City.vilnius
        let wantedDate = Date(timeIntervalSinceNow: 1000000)
        
        let unwantedCity = City.kaunas
        let unwantedDate = Date(timeIntervalSinceNow: 2000000)
        let unwantedMovies = createMovies(count: 4, city: unwantedCity, date: unwantedDate)
        sut.movies.append(contentsOf: unwantedMovies)
        
        /// when
        let showingsCount = sut.filterShowings(in: wantedCity, at: wantedDate).count
        
        /// then
        XCTAssertEqual(showingsCount, 0)
    }
    
    // MARK: - Test Helpers
    
    private func makeMockURLSession(with data: Data) -> URLSession {
        URLProtocolMock.testData = data
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        return session
    }
    
    private class URLProtocolMock: URLProtocol {
        /// this is the data we are sending back
        static var testData: Data?

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        /// as soon as loading starts, send back our test data or an empty Data instance, then end loading
        override func startLoading() {
            self.client?.urlProtocol(self, didLoad: URLProtocolMock.testData ?? Data())
            self.client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() { }
    }
    
    private struct TestData {
        static let correctData = Data(#"[{"movieID":"307366","originalTitle":"SCAN'19: Dilili à Paris (2018)","plot":"LT Dilili yra kanakų mergaitė, gyvenanti Gražiosios epochos Paryžiuje. Kartu su savo draugu kurjeriu Oreliu, ji nusprendžia savarankiškai ištirti mieste dingstančių mažų mergaičių priežastis. Į pagalbą jiems ateina daug žymių to laikmečio žmonių, įskaitant Pablo Picasso, Marcelį Proustą ir Marie Curie. Kartu jiems pavyks užkirsti kelią mieste veikiančiai slaptai organizacijai ir vėl grąžinti džiaugsmą į Paryžių. EN Dilili is a young Kanak girl living in Belle Epoque Paris. With her friend, a scooter delivery man, they investigate mysterious kidnapping of little girls. During her enquiry, she crosses paths with extraordinary men and women who help her by giving her clues. She faces the villainous organisation of the Male Masters. Together with her friend, they will brave every danger to liberate the kidnapped girls and brighten again the life in Paris. Režisierius \/ Director: Michel Ocelot Scenarijaus autorius \/ Screenplay: Michel Ocelot Editing \/ Montažas: Patrick Ducruet Kompozitorius \/ Music: Gabriel Yared Prodiuseriai \/ Producers: Christophe Rossignon, Philip Boëffard Vaidina \/ Cast: Prunelle Charles-Ambron, Enzo Ratsito, Natalie Dessay","duration":"1h 35 min","genre":"Atsivesk mamą ir tėtį","releaseDate":"07.11.2019","id":12,"title":"SCAN'19: Dilili Paryžiuje","showings":[{"venue":"Forum Cinemas Vingis","date":"2019-11-17T11:25:00Z","city":"Vilnius"},{"venue":"Forum Cinemas","city":"Kaunas","date":"2019-11-23T11:10:00Z"},{"venue":"Forum Cinemas","date":"2019-11-24T11:10:00Z","city":"Kaunas"}],"poster":"http:\/\/media.forumcinemas.lt\/1012\/Event_10134\/portrait_small\/fc_banner_320x480_v2.jpg","ageRating":"V","country":"Prancūzija, Belgija, Vokietija"}]"#.utf8)
        static let badData = Data(#"someGibberish"#.utf8)
        static let noData = Data()
    }
    
    private func createMovies(count: Int, city: City, date: Date) -> [Movie] {
        var movies = [Movie]()
        
        guard count > 0 else { return movies }
        
        for movie in 1...count {
            let newMovie = Movie(title: "someTitle\(movie)",
                                 originalTitle: "someOriginalTitle",
                                 duration: "someDuration",
                                 ageRating: "someAgeRating",
                                 genre: "someGenre",
                                 country: "someCountry",
                                 releaseDate: "someReleaseDate",
                                 poster: "somePoster.url",
                                 plot: "somePlot",
                                 showings: [])
            
            let showing = Showing(city: city.rawValue,
                                  date: date,
                                  venue: "someVenue",
                                  parentMovie: newMovie)
            
            newMovie.showings.append(showing)
            movies.append(newMovie)
        }
        
        return movies
    }
}
