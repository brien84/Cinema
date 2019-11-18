//
//  DateShowingVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DateShowingVCTests: XCTestCase {
    
    var sut: DateShowingVC!

    override func setUp() {
        sut = DateShowingVC()
    }

    override func tearDown() {
        sut = nil
    }

    func testRegisteringTableViewCell() {
        /// given
        let reuseIdentifier = "dateContainerCell"
        
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
          XCTAssertEqual(sut.tableView.rowHeight, 150)
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
    
    func testEmptyDatasourceSetsBackgroundToErrorLabel() {
        /// when
        sut.loadViewIfNeeded()
        sut.datasource = []
        
        /// then
        XCTAssertTrue(sut.tableView.backgroundView is ErrorLabel)
    }
    
    func testTableViewHasCorrectNumberOfRows() {
        /// given
        let showingsCount = 69
        sut.datasource = createShowings(count: showingsCount)
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowCount, showingsCount)
    }
    
    func testTableViewCellsHaveCorrectValuesSet() {
        /// given
        sut.datasource = createShowings(count: 69)
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        for (index, showing) in sut.datasource.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! DateContainerCell
            
            XCTAssertEqual(cell.poster.url, showing.parentMovie?.poster?.toURL())
            XCTAssertEqual(cell.title.text, showing.parentMovie?.title)
            XCTAssertEqual(cell.originalTitle.text, showing.parentMovie?.originalTitle)
            XCTAssertEqual(cell.leftLabel.text, showing.venue)
            XCTAssertEqual(cell.rightLabel.text, showing.date.asString(format: .onlyTime))
        }
    }
    
    func testSelectingRowOpensMovieContainerVC() {
       /// given
       let parentVC = UIViewController()
       _ = UINavigationController(rootViewController: parentVC)
       parentVC.addChild(sut)
       
       let testIndexPath = IndexPath(row: 0, section: 0)
       sut.datasource = createShowings(count: 6)
       let expectation = XCTestExpectation(description: "Wait for UI to update.")
       
       /// when
       sut.loadViewIfNeeded()
       sut.tableView(sut.tableView, didSelectRowAt: testIndexPath)
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           XCTAssertTrue(self.sut.parent?.navigationController?.topViewController is MovieContainerVC)
           expectation.fulfill()
       }
       
       /// then
       wait(for: [expectation], timeout: 3)
    }
    
    // MARK: - Test Helpers
    
    private func createShowings(count: Int) -> [Showing] {
        var showings = [Showing]()

        guard count > 0 else { return showings }
        
        let movie = Movie(title: "someTitle",
                          originalTitle: "someOriginalTitle",
                          duration: "someDuration",
                          ageRating: "someAgeRating",
                          genre: "someGenre",
                          country: "someCountry",
                          releaseDate: "someReleaseDate",
                          poster: "somePoster.url",
                          plot: "somePlot",
                          showings: [])

        for _ in 1...count {
            let newShowing = Showing(city: "someCity",
                                   date: Date(),
                                   venue: "someVenue",
                                   parentMovie: movie)

            showings.append(newShowing)
        }

        return showings
    }
}
