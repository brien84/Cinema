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
        let currentDate = sut.selectedDate

        // when
        sut.nextDate()

        // then
        XCTAssertLessThan(currentDate, sut.selectedDate)
    }

    func testNextDateDoesNotGoOutOfRange() {
        // given
        var index = 0

        // then
        while index < 50 {
            sut.nextDate()
            _ = sut.selectedDate
            index += 1
        }
    }

    func testNextDatePostsNotification() {
        // given
        expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: nil)

        // when
        sut.nextDate()

        // then
        waitForExpectations(timeout: 3)
    }

    func testPreviousDate() {
        // given
        sut.nextDate()
        let currentDate = sut.selectedDate

        // when
        sut.previousDate()

        // then
        XCTAssertGreaterThan(currentDate, sut.selectedDate)
    }

    func testPreviousDateDoesNotGoOutOfRange() {
        // given
        var index = 0

        // then
        while index < 50 {
            sut.previousDate()
            _ = sut.selectedDate
            index += 1
        }
    }

    func testPreviousDatePostsNotification() {
        // given
        sut.nextDate()
        expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: nil)

        // when
        sut.previousDate()

        // then
        waitForExpectations(timeout: 3)
    }

}
