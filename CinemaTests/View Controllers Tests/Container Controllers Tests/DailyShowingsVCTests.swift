//
//  DailyShowingsVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DailyShowingsVCTests: XCTestCase {

    var sut: DailyShowingsVC!

    override func setUp() {
        sut = DailyShowingsVC()
    }

    override func tearDown() {
        sut = nil
    }

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

    func testTableViewBackgroundViewIsErrorLabelWhenDatasourceEmpty() {
        // given
        sut.datasource = []

        // when
        _ = sut.tableView(sut.tableView, numberOfRowsInSection: 0)

        // then
        XCTAssertTrue(sut.tableView.backgroundView is ErrorLabel)
    }

    func testTableViewBackgroundViewIsNilWhenDatasourceIsNotEmpty() {
        // given
        let movie = TestHelper.getMovie()
        sut.datasource = movie.showings

        // when
        _ = sut.tableView(sut.tableView, numberOfRowsInSection: 0)

        // then
        XCTAssertNil(sut.tableView.backgroundView)
    }

    func testTableViewCellsHaveCorrectValuesSet() {
        // given
        let movie = TestHelper.getMovie()
        sut.datasource = movie.showings

        // then
        for (index, showing) in sut.datasource.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            // swiftlint:disable:next force_cast
            let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! DailyShowingsCell

            XCTAssertEqual(cell.poster.url, showing.parentMovie?.poster)
            XCTAssertEqual(cell.title.text, showing.parentMovie?.title)
            XCTAssertEqual(cell.originalTitle.text, showing.parentMovie?.originalTitle)
            XCTAssertEqual(cell.venue.text, showing.venue)
            XCTAssertEqual(cell.time.text, showing.date.asString(format: .onlyTime))
            XCTAssertEqual(cell.screenType.text, showing.is3D ? "3D" : nil)
        }
    }

    func testSelectingTableViewRowOpensMovieViewController() {
        // given
        let parentVC = UIViewController()
        parentVC.addChild(sut)
        _ = UINavigationController(rootViewController: parentVC)

        let movie = TestHelper.getMovie()
        sut.datasource = movie.showings
        let indexPath = IndexPath(row: 0, section: 0)

        let expectation = self.expectation(description: "Wait for UI to update.")

        // when
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.sut.parent?.navigationController?.topViewController is MovieViewController)
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
    }

}
