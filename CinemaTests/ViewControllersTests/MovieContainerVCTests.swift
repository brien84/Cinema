//
//  MovieContainerVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieViewControllerTests: XCTestCase {
    
    var sut: MovieViewController!

    override func setUp() {
        sut = MovieViewController(with: movie)
    }

    override func tearDown() {
        sut = nil
    }

    func testNavigationItemTitleIsMovieTitle() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.navigationItem.title, movie.title)
    }
    
    func testMovieContainerBackgroundColorIsLight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.view.backgroundColor, Constants.Colors.light)
    }
    
    // MARK: - Test Helpers
    
    private var movie: Movie {
        return Movie(title: "someTitle",
                     originalTitle: "someOriginalTitle",
                     duration: "someDuration",
                     ageRating: "someAgeRating",
                     genre: "someGenre",
                     country: "someCountry",
                     releaseDate: "someReleaseDate",
                     poster: "somePoster.url",
                     plot: "somePlot",
                     showings: [])
    }
}
