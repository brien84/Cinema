//
//  DailyViewControllerTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DailyViewControllerTests: XCTestCase {

    var sut: DailyViewController!

    override func tearDown() {
        sut = nil
    }

    func testViewBackgroundColorIsTransparentBlack() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.view.backgroundColor, .transparentBlackC)
    }

    // MARK: SegmentedControl

    func testSegmentedControlSomeSegmentIsSelected() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertNotEqual(sut.segmentedControl.selectedSegmentIndex, -1)
    }

    func testSegmentedControlIsDisabledBeforeFetching() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertFalse(sut.segmentedControl.isEnabled)
    }

    func testSegmentedControlIsEnabledAfterFetching() {
        // given
        sut = DailyViewController(movieManager: MovieManagerMock(true))
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        _ = sut.view
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)

        XCTAssertTrue(sut.segmentedControl.isEnabled)
    }

    // MARK: ContainerView

    func testContainerViewContainsLoadingViewWhileFetching() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        let loadingView = sut.containerView.subviews.first { type(of: $0) == LoadingView.self }

        XCTAssertNotNil(loadingView)
    }

    func testContainerViewDoesNotContainLoadingViewAfterSuccessfulFetch() {
        // given
        sut = DailyViewController(movieManager: MovieManagerMock(true))
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        _ = sut.view
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
        let loadingView = sut.containerView.subviews.first { type(of: $0) == LoadingView.self }

        XCTAssertNil(loadingView)
    }

    func testContainerViewContainsLoadingViewAfterFailedFetch() {
        // given
        sut = DailyViewController(movieManager: MovieManagerMock(false))
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        _ = sut.view
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
        let loadingView = sut.containerView.subviews.first { type(of: $0) == LoadingView.self }

        XCTAssertNotNil(loadingView)
    }


    // MARK: LeftBarButtonItem

    func testLeftBarButtonItemIsNotNil() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
    }

    func testLeftBarButtonItemIsDisabledBeforeFetching() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail("leftBarButtonItem is nil!") }

        XCTAssertFalse(button.isEnabled)
    }

    func testLeftBarButtonItemIsEnabledAfterFetching() {
        // given
        sut = DailyViewController(movieManager: MovieManagerMock(true))
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        _ = sut.view
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail("leftBarButtonItem is nil!") }

        XCTAssertTrue(button.isEnabled)
    }

    func testLeftBarButtonImageIsOptionsWhenFirstDateIsSelected() {
        // given
        let dateSelector = DateSelectorMock(true, false)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view
        dateSelector.nextDate()

        // then
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail("leftBarButtonItem is nil!") }

        XCTAssertEqual(button.image, .options)
    }

    func testLeftBarButtonImageIsLeftWhenFirstDateIsNotSelected() {
        // given
        let dateSelector = DateSelectorMock(false, false)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view
        dateSelector.nextDate()

        // then
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail("leftBarButtonItem is nil!") }

        XCTAssertEqual(button.image, .left)
    }

    // MARK: RightBarButtonItem

    func testRightBarButtonItemIsNotNil() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }

    func testRightBarButtonItemIsDisabledBeforeFetching() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail("rightBarButtonItem is nil!") }

        XCTAssertFalse(button.isEnabled)
    }

    func testRightBarButtonItemIsEnabledAfterFetching() {
        // given
        sut = DailyViewController(movieManager: MovieManagerMock(true))
        let expectation = self.expectation(description: "Wait for fetching to end.")

        // when
        _ = sut.view
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail("rightBarButtonItem is nil!") }

        XCTAssertTrue(button.isEnabled)
    }

    func testRightBarButtonIsEnabledWhenLastDateIsNotSelected() {
        // given
        let dateSelector = DateSelectorMock(false, false)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view
        dateSelector.nextDate()

        // then
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail("rightBarButtonItem is nil!") }

        XCTAssertTrue(button.isEnabled)
    }

    func testRightBarButtonIsDisabledWhenLastDateIsSelected() {
        // given
        let dateSelector = DateSelectorMock(false, true)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view
        dateSelector.nextDate()

        // then
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail("rightBarButtonItem is nil!") }

        XCTAssertFalse(button.isEnabled)
    }

    // MARK: NavigationItemTitle

    func testNavigationItemTitleIsNotNil() {
        // given
        sut = DailyViewController()

        // when
        _ = sut.view

        // then
        XCTAssertNotNil(sut.navigationItem.title)
    }

    func testNavigationItemTitleIsSetToDate() {
        // given
        let dateSelector = DateSelectorMock(false, false)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.navigationItem.title, dateSelector.selectedDate.asString(format: .monthNameAndDay))
    }

    func testNavigationItemTitleIsUpdatedWhenDateChanges() {
        // given
        let dateSelector = DateSelectorMock(false, false)
        sut = DailyViewController(dateSelector: dateSelector)

        // when
        _ = sut.view
        let oldDate = dateSelector.selectedDate
        dateSelector.selectedDate = Date(timeIntervalSinceNow: 864000)
        dateSelector.nextDate()

        // then
        XCTAssertNotEqual(sut.navigationItem.title, oldDate.asString(format: .monthNameAndDay))
    }

    // MARK: - Test Helpers

    private final class DateSelectorMock: DateSelectable {
        var selectedDate = Date()
        var isFirstDateSelected: Bool
        var isLastDateSelected: Bool

        init(_ isFirstDateSelected: Bool, _ isLastDateSelected: Bool) {
            self.isFirstDateSelected = isFirstDateSelected
            self.isLastDateSelected = isLastDateSelected
        }

        func previousDate() {
            postNotification()
        }

        func nextDate() {
            postNotification()
        }

        private func postNotification() {
            NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil)
        }
    }

    private final class MovieManagerMock: MovieManageable {
        var movies = [Movie]()

        private var isFetchSuccessful: Bool

        init(_ isFetchSuccessful: Bool) {
            self.isFetchSuccessful = isFetchSuccessful
        }

        func fetch(using session: URLSession = .shared, completion: @escaping (Result<Void, Error>) -> Void) {

            var data: Data

            if isFetchSuccessful {
                guard let asset = NSDataAsset(name: "testData") else { return XCTFail("testData file is not found!") }
                data = asset.data
            } else {
                data = Data()
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                movies = try decoder.decode([Movie].self, from: data)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

}