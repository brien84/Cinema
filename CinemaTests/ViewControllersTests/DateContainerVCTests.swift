//
//  DateContainerVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DateContainerVCTests: XCTestCase {
    
    var sut: DateContainerVC!

    override func tearDown() {
        sut = nil
    }

    func testLeftBarButtonItemIsNavigationButton() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertTrue(sut.navigationItem.leftBarButtonItem is NavigationButton)
    }
    
    func testLeftBarButtonItemIsDisabled() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem as! NavigationButton
        XCTAssertFalse(button.isEnabled)
    }
    
    func testLeftBarButtonDelegateIsSet() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem as! NavigationButton
        XCTAssertNotNil(button.delegate)
    }
    
    func testLeftBarButtonItemIsEnabledAfterSuccessfulFetch() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        DispatchQueue.main.async {
            let button = self.sut.navigationItem.leftBarButtonItem as! NavigationButton
            XCTAssertTrue(button.isEnabled)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRightBarButtonItemIsNavigationButton() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem is NavigationButton)
    }
    
    func testRightBarButtonItemIsDisabled() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let button = sut.navigationItem.rightBarButtonItem as! NavigationButton
        XCTAssertFalse(button.isEnabled)
    }
    
    func testRightBarButtonItemIsEnabledAfterSuccessfulFetch() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        DispatchQueue.main.async {
            let button = self.sut.navigationItem.rightBarButtonItem as! NavigationButton
            XCTAssertTrue(button.isEnabled)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRightBarButtonDelegateIsSet() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let button = sut.navigationItem.rightBarButtonItem as! NavigationButton
        XCTAssertNotNil(button.delegate)
    }
    
    func testLeftBarButtonImageIsOptions() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        NotificationCenter.default.post(name: .dateIndexDidChange, object: nil, userInfo: [Constants.UserInfo.isIndexZero: true])
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem as! NavigationButton
        XCTAssertEqual(button.image, Constants.Images.options)
    }
    
    func testLeftBarButtonImageIsLeftArrow() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        NotificationCenter.default.post(name: .dateIndexDidChange, object: nil, userInfo: [Constants.UserInfo.isIndexZero: false])
        
        /// then
        let button = sut.navigationItem.leftBarButtonItem as! NavigationButton
        XCTAssertEqual(button.image, Constants.Images.left)
    }
    
    func testNavigationTitleIsSet() {
        /// given
        let date = Date()
        sut = DateContainerVC(dateManager: DateManagerMock(dates: [date]), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.navigationItem.title, date.asString(format: .monthNameAndDay))
    }
    
    func testTappingRightNavigationButtonIncreasesDate() {
        /// given
        let firstDate = Date()
        let secondDate = Date(timeIntervalSinceNow: 10000000)
        sut = DateContainerVC(dateManager: DateManagerMock(dates: [firstDate, secondDate]), movieManager: MovieManagerMock())
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(self.sut.navigationItem.title, firstDate.asString(format: .monthNameAndDay))
        let button = self.sut.navigationItem.rightBarButtonItem as! NavigationButton
        self.sut.buttonTap(button)
        XCTAssertEqual(self.sut.navigationItem.title, secondDate.asString(format: .monthNameAndDay))
    }
    
    func testTappingLeftNavigatonButtonOpensOptionsVC() {
        /// given
        sut = DateContainerVC(dateManager: DateManagerMock(), movieManager: MovieManagerMock())
        _ = UINavigationController(rootViewController: sut)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        
        let button = self.sut.navigationItem.leftBarButtonItem as! NavigationButton
        self.sut.buttonTap(button)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.sut.navigationController?.topViewController is OptionsVC)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testTappingLeftNavigationButtonDecreasesDate() {
        /// given
        let firstDate = Date()
        let secondDate = Date(timeIntervalSinceNow: 10000000)
        sut = DateContainerVC(dateManager: DateManagerMock(dates: [firstDate, secondDate]), movieManager: MovieManagerMock())

        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertEqual(self.sut.navigationItem.title, firstDate.asString(format: .monthNameAndDay))
        
        let rightButton = self.sut.navigationItem.rightBarButtonItem as! NavigationButton
        self.sut.buttonTap(rightButton)
        
        XCTAssertEqual(self.sut.navigationItem.title, secondDate.asString(format: .monthNameAndDay))
        
        let leftButton = self.sut.navigationItem.leftBarButtonItem as! NavigationButton
        self.sut.buttonTap(leftButton)
        
        XCTAssertEqual(self.sut.navigationItem.title, firstDate.asString(format: .monthNameAndDay))
    }
    
    // MARK: - Test Helpers
    
    private struct DateManagerMock: DateManagerProtocol {
        var dates: [Date]
        
        var currentIndex: Int = 0 {
            didSet {
                let info = self.currentIndex == 0 ? [Constants.UserInfo.isIndexZero: true] : [Constants.UserInfo.isIndexZero: false]
                NotificationCenter.default.post(name: .dateIndexDidChange, object: nil, userInfo: info)
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
