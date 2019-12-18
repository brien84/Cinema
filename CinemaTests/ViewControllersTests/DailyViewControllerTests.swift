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
        NotificationCenter.default.post(name: .DateManagerIndexDidChange, object: nil, userInfo: [Constants.UserInfo.isIndexZero: true])
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem
        XCTAssertEqual(button?.image, Constants.Images.options)
    }
    
    func testLeftBarButtonImageIsLeftArrow() {
        /// given
        sut = DailyViewController(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        NotificationCenter.default.post(name: .DateManagerIndexDidChange, object: nil, userInfo: [Constants.UserInfo.isIndexZero: false])
        
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
    
    private struct DateManagerMock: DateManagerProtocol {
        var dates: [Date]
        
        var currentIndex: Int = 0 {
            didSet {
                let info = self.currentIndex == 0 ? [Constants.UserInfo.isIndexZero: true] : [Constants.UserInfo.isIndexZero: false]
                NotificationCenter.default.post(name: .DateManagerIndexDidChange, object: nil, userInfo: info)
            }
        }
        
        var selectedDate: Date {
            return dates[currentIndex]
        }
        
        init(dates: [Date] = [Date()]) {
            self.dates = dates
        }
        
        mutating func decreaseDate() {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }
        
        mutating func increaseDate() {
            guard let lastIndex = dates.indices.last else { fatalError("Date array is empty!") }
            
            if currentIndex != lastIndex {
                currentIndex += 1
            }
        }
    }
    
    private class MovieManagerMock: MovieManagerProtocol {
        private var isFetchSuccessful: Bool
        
        var movies: [Movie] = []
        
        init(isFetchSuccessful: Bool = true) {
            self.isFetchSuccessful = true
        }
        
        func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> ()) {
            completion(self.isFetchSuccessful ? .success(()) : .failure(TestError.someError))
        }
        
        func getMovies(in city: City, at date: Date) -> [Movie] {
            return []
        }
        
        func getShowings(in city: City, at date: Date) -> [Showing] {
            return []
        }
    }
    
    private enum TestError: Error {
        case someError
    }
}
