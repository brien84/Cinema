//
//  OptionsViewControllerTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

class OptionsViewControllerTests: XCTestCase {

    var sut: OptionsViewController!

    override func setUp() {
        sut = OptionsViewController()
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

    func testTableViewSeparatorStyleIsNone() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.tableView.separatorStyle, .none)
    }

    func testTableViewScrollIsDisabled() {
        // when
        _ = sut.view

        // then
        XCTAssertFalse(sut.tableView.isScrollEnabled)
    }

    func testTableViewHasCorrectNumberOfRows() {
        // given
        let cityCount = City.allCases.count

        // when
        _ = sut.view

        // then
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowCount, cityCount)
    }

    func testTableViewSelectingRowSendsNotification() {
        // given
        expectation(forNotification: .OptionsCityDidChange, object: nil, handler: nil)

        // when
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then
        waitForExpectations(timeout: 3)
    }

    // MARK: NavigationBar

    func testNavigationBarIsHidden() {
        // given
        _ = UINavigationController(rootViewController: sut)

        // when
        _ = sut.view

        // then
        XCTAssertTrue(sut.navigationController?.isNavigationBarHidden ?? false)
    }

    func testNavigationBarIsUnhiddenWhenViewDisappears() {
        // given
        _ = UINavigationController(rootViewController: sut)

        // when
        _ = sut.view
        sut.viewWillDisappear(false)

        // then
        XCTAssertFalse(sut.navigationController?.isNavigationBarHidden ?? true)
    }

    // MARK: TableHeaderView

    func testTableViewHeaderIsNotNil() {
        // when
        _ = sut.view

        // then
        XCTAssertNotNil(sut.tableView.tableHeaderView)
    }

    func testTableViewHeaderViewIsUILabel() {
        // when
        _ = sut.view
        let headerView = sut.tableView.tableHeaderView as? UILabel

        // then
        XCTAssertNotNil(headerView)
    }

    func testTableViewHeaderViewTextAlignmentIsCenter() {
        // when
        _ = sut.view
        guard let headerView = sut.tableView.tableHeaderView as? UILabel else {
            return XCTFail("headerView is not UILabel")
        }

        // then
        XCTAssertEqual(headerView.textAlignment, .center)
    }

    func testTableViewHeaderViewTextColorIsLight() {
         // when
         _ = sut.view
         guard let headerView = sut.tableView.tableHeaderView as? UILabel else {
             return XCTFail("headerView is not UILabel")
         }

         // then
         XCTAssertEqual(headerView.textColor, .lightC)
     }

}
