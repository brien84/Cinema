//
//  MovieShowingsVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieShowingsVCTests: XCTestCase {

    var sut: MovieShowingsVC!

    override func setUp() {
        sut = MovieShowingsVC()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: TableView

    func testTableViewRegistersCell() {
        // given
        let reuseIdentifier = "Cell"

        // when
        _ = sut.view

        // then
        guard let nibs = sut.tableView.value(forKey: "_cellClassDict") as? [String: Any] else {
            return XCTFail("nibs dictionary is nil!")
        }

        XCTAssertTrue(nibs.contains { $0.key == reuseIdentifier })
    }

    func testTableViewTopContentInsetIsGreaterThanZero() {
        // when
        _ = sut.view

        // then
        XCTAssertGreaterThan(sut.tableView.contentInset.top, 0)
    }

    func testTableViewBackgroundColorIsDark() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.tableView.backgroundColor, .darkC)
    }

    func testTableViewSeparatorColorIsGray() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.tableView.separatorColor, .grayC)
    }

    func testTableViewFooterViewIsNotNil() {
        // when
        _ = sut.view

        // then
        XCTAssertNotNil(sut.tableView.tableFooterView)
    }

    func testTableViewHasCorrectNumberOfRows() {
        // given
        let movie = TestHelper.getMovie()
        let showingsCount = movie.showings.count
        sut.datasource = movie.showings

        // when
        _ = sut.view

        // then
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowCount, showingsCount)
    }

    func testTableViewCellsHaveCorrectValuesSet() {
        // given
        let movie = TestHelper.getMovie()
        sut.datasource = movie.showings

        // then
        for (index, showing) in sut.datasource.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            // swiftlint:disable:next force_cast
            let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! MovieShowingsCell

            XCTAssertEqual(cell.date.text, showing.date.asString(format: .monthNameAndDay))
            XCTAssertEqual(cell.time.text, showing.date.asString(format: .onlyTime))
            XCTAssertEqual(cell.venue.text, showing.venue)
            XCTAssertEqual(cell.screenType.text, showing.is3D ? "3D" : nil)
        }
    }
}
