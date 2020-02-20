//
//  DateSelectorTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DateSelectorTests: XCTestCase {

    var sut: DateSelector!

    override func setUp() {
        sut = DateSelector()
    }

    override func tearDown() {
        sut = nil
    }

    func testNextDate() {
        // given
        let currentDate = sut.current

        // when
        sut.next()

        // then
        XCTAssertLessThan(currentDate, sut.current)
    }

    func testNextDateDoesNotGoOutOfRange() {
        // given
        var index = 0

        // then
        while index < 50 {
            sut.next()
            _ = sut.current
            index += 1
        }
    }

    func testNextDatePostsNotification() {
        // given
        expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: nil)

        // when
        sut.next()

        // then
        waitForExpectations(timeout: 3)
    }

    func testPreviousDate() {
        // given
        sut.next()
        let currentDate = sut.current

        // when
        sut.previous()

        // then
        XCTAssertGreaterThan(currentDate, sut.current)
    }

    func testPreviousDateDoesNotGoOutOfRange() {
        // given
        var index = 0

        // then
        while index < 50 {
            sut.previous()
            _ = sut.current
            index += 1
        }
    }

    func testPreviousDatePostsNotification() {
        // given
        sut.next()
        expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: nil)

        // when
        sut.previous()

        // then
        waitForExpectations(timeout: 3)
    }

}
