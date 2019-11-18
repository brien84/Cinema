//
//  MovieShowingVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class MovieShowingVCTests: XCTestCase {
    
    var sut: MovieShowingVC!

    override func setUp() {
        sut = MovieShowingVC()
    }

    override func tearDown() {
        sut = nil
    }

    func testRegisteringTableViewCell() {
        /// given
        let reuseIdentifier = "movieShowingCell"
        
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
         XCTAssertEqual(sut.tableView.rowHeight, 80)
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
            let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! MovieShowingCell
            
            XCTAssertEqual(cell.time.text, showing.date.asString(format: .onlyTime))
            XCTAssertEqual(cell.date.text, showing.date.asString(format: .monthNameAndDay))
            XCTAssertEqual(cell.venue.text, showing.venue)
        }
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
