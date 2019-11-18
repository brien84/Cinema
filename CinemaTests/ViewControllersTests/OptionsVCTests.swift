//
//  OptionsVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class OptionsVCTests: XCTestCase {
    
    var sut: OptionsVC!

    override func setUp() {
        sut = OptionsVC()
    }

    override func tearDown() {
        sut = nil
    }

    func testRegisteringTableViewCell() {
        /// given
        let reuseIdentifier = "optionsCell"
        
        /// when
        sut.loadViewIfNeeded()
        guard let nibs = sut.tableView.value(forKey: "_cellClassDict") as? [String : Any]
            else { return XCTFail() }
        
        /// then
        XCTAssertTrue(nibs.contains { $0.key == reuseIdentifier })
    }
    
    func testSetsTableViewFooterView() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertNotNil(sut.tableView.tableFooterView)
    }
    
    func testTableViewRowHeight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.rowHeight, 50)
    }
    
    func testTableViewBackgroundColorIsLight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.backgroundColor, Constants.Colors.light)
    }
    
    func testTableViewSeparatorColorIsBlue() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.separatorColor, Constants.Colors.blue)
    }
    
    func testTableViewScrollingIsDisabled() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertFalse(sut.tableView.isScrollEnabled)
    }
    
    func testNavigationItemTitleIsSet() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.navigationItem.title, "Pasirinkite miestą")
    }
    
    func testTableViewHasCorrectNumberOfRows() {
        /// given
        let count = City.allCases.count
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowCount, count)
    }
    
    func testSelectingRowSendsNotification() {
        /// given
        let notificationExpectation = expectation(forNotification: .cityDidChange, object: nil, handler: nil)
        
        /// when
        sut.loadViewIfNeeded()
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
}
