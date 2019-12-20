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

    func testLeftBarButtonItemIsNotNil() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
    }
    
    func testRightBarButtonItemIsNotNil() {
         /// given
         sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
         
         /// when
         sut.loadViewIfNeeded()
         
         /// then
         XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
     }
    
    func testLeftBarButtonItemIsDisabled() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail() }
        
        /// then
        XCTAssertFalse(button.isEnabled)
    }
    
    func testRightBarButtonItemIsDisabled() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail() }
        
        /// then
        XCTAssertFalse(button.isEnabled)
    }

    func testLeftBarButtonItemIsEnabledAfterSuccessfulFetch() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.leftBarButtonItem else { return XCTFail() }
        
        DispatchQueue.main.async {
            XCTAssertTrue(button.isEnabled)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRightBarButtonItemIsEnabledAfterSuccessfulFetch() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.rightBarButtonItem else { return XCTFail() }
        
        DispatchQueue.main.async {
            XCTAssertTrue(button.isEnabled)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }

    func testLeftBarButtonImageIsOptions() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil, userInfo: [DateManagerMock.isFirstDateSelectedKey : true])
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem
        XCTAssertEqual(button?.image, Constants.Images.options)
    }
    
    func testLeftBarButtonImageIsLeftArrow() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil, userInfo: [DateManagerMock.isFirstDateSelectedKey : false])
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem
        XCTAssertEqual(button?.image, Constants.Images.left)
    }
    
    func testNavigationTitleIsSet() {
        /// given
        let date = Date()
        sut = DailyViewController(dateManager: DateManagerMock(dates: [date]), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.navigationItem.title, date.asString(format: .monthNameAndDay))
    }
    
    // MARK: - Test Helpers
    
    // TODO: RENAME!
    private struct DateManagerMock: DateSelectable {
        
        static let isFirstDateSelectedKey = "DateSelectorIsFirstDateSelected"
        
        var dates: [Date]
        
        var currentIndex: Int = 0 {
            didSet {
                let info = self.currentIndex == 0 ? [DateManagerMock.isFirstDateSelectedKey : true] : [DateManagerMock.isFirstDateSelectedKey: false]
                NotificationCenter.default.post(name: .DateSelectorDateDidChange, object: nil, userInfo: info)
            }
        }
        
        var selectedDate: Date {
            return dates[currentIndex]
        }
        
        init(dates: [Date] = [Date()]) {
            self.dates = dates
        }
        
        mutating func previousDate() {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }
        
        mutating func nextDate() {
            guard let lastIndex = dates.indices.last else { fatalError("Date array is empty!") }
            
            if currentIndex != lastIndex {
                currentIndex += 1
            }
        }
    }
    
    private class MovieManagerMock: MovieManageable {
        private var isFetchSuccessful: Bool
        
        var movies: [Movie] = []
        
        init(isFetchSuccessful: Bool = true) {
            self.isFetchSuccessful = true
        }
        
        func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> ()) {
            completion(self.isFetchSuccessful ? .success(()) : .failure(TestError.someError))
        }
    }
    
    private enum TestError: Error {
        case someError
    }
}
