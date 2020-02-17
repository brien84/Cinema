//
//  MovieDetailViewVCTests.swift
//  CinemaTests
//
//  Created by Marius on 2020-02-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieDetailViewVCTests: XCTestCase {

    var sut: MovieDetailViewVC!

    override func setUp() {
        sut = MovieDetailViewVC(movie: movie)
    }

    override func tearDown() {
        sut = nil
    }

    func testViewBackgroundColorIsDark() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.view.backgroundColor, .darkC)
    }

    // MARK: - Test Helpers

    private var movie: Movie {
        return TestHelper.getMovie()
    }
}
