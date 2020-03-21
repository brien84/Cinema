//
//  MovieDetailsVCTests.swift
//  CinemaTests
//
//  Created by Marius on 2020-02-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

class MovieDetailsVCTests: XCTestCase {

    var sut: MovieDetailsVC!

    override func setUp() {
        sut = MovieDetailsVC(movie: movie)
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

    // MARK: TestHelper:

    private var movie: Movie {
        return TestHelper.generateMovie()
    }
}
