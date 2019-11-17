//
//  MovieContainerVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieContainerVCTests: XCTestCase {
    
    var sut: MovieContainerVC!

    override func setUp() {
        sut = MovieContainerVC()
        sut.movie = movie
    }

    override func tearDown() {
        sut = nil
    }

    func testNavigationItemTitleIsMovieTitle() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.navigationItem.title, sut.movie.title)
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
                     poster: "somePoster",
                     plot: "somePlot",
                     showings: [])
    }
}
