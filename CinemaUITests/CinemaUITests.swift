//
//  CinemaUITests.swift
//  CinemaUITests
//
//  Created by Marius on 2020-02-23.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest

class CinemaUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["ui-testing"]
        app.launch()

        // Selects city on app startup.
        app.optionsSelectCity(0)
    }

    override func tearDown() {
        app = nil
    }

    func testDailyShowingsExistsAfterSelectingCity() {

        XCTAssertTrue(app.dailyShowings.exists)
    }

    func testDailyVCSegmentedControlSwitching() {

        app.dailyVCSegmentedControl.selectButton(0)
        XCTAssertTrue(app.dailyMovies.exists)

        app.dailyVCSegmentedControl.selectButton(1)
        XCTAssertTrue(app.dailyShowings.exists)
    }

    func testDailyVCOptionsNavButtonOpensOptionsVC() {

        app.dailyVCOptionsNavButton.tap()

        XCTAssertTrue(app.optionsVCTableView.exists)
    }

    func testTappingDailyVCRightNavButtonUpdatesDailyShowings() {

        let initialCount = app.dailyShowings.cellCount
        app.dailyVCRightNavButton.tap()

        XCTAssertNotEqual(initialCount, app.dailyShowings.cellCount)
    }

    func testDailyVCRightNavButtonGetsDisabled() {

        app.dailyVCRightNavButton.tap(withNumberOfTaps: 10, numberOfTouches: 1)
        app.dailyVCRightNavButton.tap(withNumberOfTaps: 10, numberOfTouches: 1)
        app.dailyVCRightNavButton.tap(withNumberOfTaps: 10, numberOfTouches: 1)

        XCTAssertFalse(app.dailyVCRightNavButton.isEnabled)
    }

    func testTappingDailyVCLeftNavButtonUpdatesDailyShowings() {

        app.dailyVCRightNavButton.tap()

        let initialCount = app.dailyShowings.cellCount
        app.dailyVCLeftNavButton.tap()

        XCTAssertNotEqual(initialCount, app.dailyShowings.cellCount)
    }

    func testTappingDailyVCRightNavButtonUpdatesDailyMovies() {

        app.dailyVCSegmentedControl.selectButton(0)

        let initialCount = app.dailyMovies.cellCount
        app.dailyVCRightNavButton.tap()

        XCTAssertNotEqual(initialCount, app.dailyMovies.cellCount)
    }

    func testTappingDailyVCLeftNavButtonUpdatesDailyMovies() {

        app.dailyVCSegmentedControl.selectButton(0)
        app.dailyVCRightNavButton.tap()

        let initialCount = app.dailyMovies.cellCount
        app.dailyVCLeftNavButton.tap()

        XCTAssertNotEqual(initialCount, app.dailyMovies.cellCount)
    }

    func testChangingCityFromDailyShowings() {

        let initialCount = app.dailyShowings.cellCount
        app.dailyVCOptionsNavButton.tap()
        app.optionsSelectCity(1)

        XCTAssertNotEqual(initialCount, app.dailyShowings.cellCount)
    }

    func testChangingCityFromDailyMovies() {

        app.dailyVCSegmentedControl.selectButton(0)

        let initialCount = app.dailyMovies.cellCount
        app.dailyVCOptionsNavButton.tap()
        app.optionsSelectCity(1)

        XCTAssertNotEqual(initialCount, app.dailyMovies.cellCount)
    }

    func testSelectingDailyShowingsCellOpensMovieView() {

        app.dailyShowings.selectCell(0)

        XCTAssertTrue(app.movieDetails.exists)
    }

    func testSelectingDailyMoviessCellOpensMovieView() {

        app.dailyVCSegmentedControl.selectButton(0)

        app.dailyMovies.selectCell(0)

        XCTAssertTrue(app.movieDetails.exists)
    }

    func testMovieVCSegmentedControlSwitching() {

        app.dailyShowings.selectCell(0)

        app.movieVCSegmentedControl.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.movieShowings.exists)

        app.movieVCSegmentedControl.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.movieDetails.exists)
    }

    func testMovieVCNavigationBarBackButtonReturnsToDailyShowings() {

        app.dailyShowings.selectCell(0)

        app.navigationBars.buttons.element.tap()

        XCTAssertTrue(app.dailyShowings.exists)
    }

    func testSwipingLeftUpdatesDailyShowings() {

        let initialCount = app.dailyShowings.cellCount
        app.swipeLeft()

        XCTAssertNotEqual(initialCount, app.dailyShowings.cellCount)
    }

    func testSwipingRightUpdatesDailyShowings() {

        app.swipeLeft()

        let initialCount = app.dailyShowings.cellCount
        app.swipeRight()

        XCTAssertNotEqual(initialCount, app.dailyShowings.cellCount)
    }
}

extension XCUIApplication {

    // MARK: DailyViewController:

    var dailyVCSegmentedControl: XCUIElement {
        return segmentedControls["UI-DailyVCSegmented"]
    }

    var dailyVCOptionsNavButton: XCUIElement {
        return buttons["UI-DailyVCOptionsButton"]
    }

    var dailyVCLeftNavButton: XCUIElement {
        return buttons["UI-DailyVCLeftButton"]
    }

    var dailyVCRightNavButton: XCUIElement {
        return buttons["UI-DailyVCRightButton"]
    }

    // MARK: MovieViewController:

    var movieVCSegmentedControl: XCUIElement {
        return segmentedControls["UI-MovieVCSegmented"]
    }

    // MARK: OptionsViewController:

    var optionsVCTableView: XCUIElement {
        return tables["UI-OptionsVCTable"]
    }

    func optionsSelectCity(_ index: Int) {
        optionsVCTableView.selectCell(index)
    }

    // MARK: DailyMoviesVC:

    var dailyMovies: XCUIElement {
        return collectionViews["UI-DailyMoviesCollection"]
    }

    // MARK: DailyShowingsVC:

    var dailyShowings: XCUIElement {
        return tables["UI-DailyShowingsTable"]
    }

    // MARK: MovieDetailsVC:

    var movieDetails: XCUIElement {
        return otherElements["UI-MovieDetailsView"]
    }

    // MARK: MovieShowingsVC:

    var movieShowings: XCUIElement {
        return tables["UI-MovieShowingsTable"]
    }
}

extension XCUIElement {
    func selectButton(_ index: Int) {
        self.buttons.element(boundBy: index).tap()
    }

    func selectCell(_ index: Int) {
        self.cells.element(boundBy: index).tap()
    }

    var cellCount: Int {
        return self.cells.count
    }
}
