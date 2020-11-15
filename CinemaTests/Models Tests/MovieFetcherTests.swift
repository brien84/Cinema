//
//  MovieFetcherTests.swift
//  CinemaTests
//
//  Created by Marius on 2020-11-15.
//  Copyright © 2020 Marius. All rights reserved.
//

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

}
