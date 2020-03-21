//
//  MovieContainerVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

class MovieViewControllerTests: XCTestCase {

    var sut: MovieViewController!

    override func setUp() {
        sut = MovieViewController(with: movie)
    }

    override func tearDown() {
        sut = nil
    }

    func testViewBackgroundColorIsTransparentBlack() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.view.backgroundColor, .transparentBlackC)
    }

    func testSegmentedControlSomeSegmentIsSelected() {
        // when
        _ = sut.view

        // then
        XCTAssertNotEqual(sut.segmentedControl.selectedSegmentIndex, -1)
    }

    func testNavigationItemTitleIsMovieTitle() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.navigationItem.title, movie.title)
    }

    // MARK: TestHelper:

    private var movie: Movie {
        return TestHelper.generateMovie()
    }
}
