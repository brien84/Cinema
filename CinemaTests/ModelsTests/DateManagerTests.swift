//
//  DateManagerTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DateManagerTests: XCTestCase {
    
    var sut: DateManager!

    override func setUp() {
        sut = DateManager()
    }

    override func tearDown() {
        sut = nil
    }

    func testIncreaseDate() {
        /// given
        let currentDate = sut.selectedDate
        
        /// when
        sut.increaseDate()
        
        /// then
        XCTAssertLessThan(currentDate, sut.selectedDate)
    }
    
    func testIncreaseDateDoesNotExceedMaxIndex() {
        var i = 0
        while i < 100 {
            sut.increaseDate()
            i += 1
        }
    }
    
    func testDecreaseDate() {
        /// given
        sut.increaseDate()
        let currentDate = sut.selectedDate
        
        /// when
        sut.decreaseDate()
        
        /// then
        XCTAssertGreaterThan(currentDate, sut.selectedDate)
    }
    
    func testDataManagerSendsNotificationWhenIndexChanges() {
        /// given
        let notificationExpectation = expectation(forNotification: .DateManagerIndexDidChange, object: nil, handler: nil)
        
        /// when
        sut.increaseDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testDataManagerNotifcationIsIndexZeroIsFalse() {
        /// given
        let handler = { (notification: Notification) -> Bool in
            guard let isIndexZero = notification.userInfo?[Constants.UserInfo.isIndexZero] as? Bool
                else { return false }
        
            if isIndexZero {
                return false
            } else {
                return true
            }
        }
        
        let notificationExpectation = expectation(forNotification: .DateManagerIndexDidChange, object: nil, handler: handler)
        
        /// when
        sut.increaseDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testDataManagerNotifcationIsIndexZeroIsTrue() {
        /// given
        sut.increaseDate()
        
        let handler = { (notification: Notification) -> Bool in
            guard let isIndexZero = notification.userInfo?[Constants.UserInfo.isIndexZero] as? Bool
                else { return false }
        
            if isIndexZero {
                return true
            } else {
                return false
            }
        }
        
        let notificationExpectation = expectation(forNotification: .DateManagerIndexDidChange, object: nil, handler: handler)
        
        /// when
        sut.decreaseDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
}
