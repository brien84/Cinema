//
//  DateSelectorTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DateSelectorTests: XCTestCase {
    
    var sut: DateSelector!

    override func setUp() {
        sut = DateSelector()
    }

    override func tearDown() {
        sut = nil
    }

    func testIncreaseDate() {
        /// given
        let currentDate = sut.selectedDate
        
        /// when
        sut.nextDate()
        
        /// then
        XCTAssertLessThan(currentDate, sut.selectedDate)
    }
    
    func testIncreaseDateDoesNotExceedMaxIndex() {
        var i = 0
        while i < 100 {
            sut.nextDate()
            i += 1
        }
    }
    
    func testDecreaseDate() {
        /// given
        sut.nextDate()
        let currentDate = sut.selectedDate
        
        /// when
        sut.previousDate()
        
        /// then
        XCTAssertGreaterThan(currentDate, sut.selectedDate)
    }
    
    func testDataManagerSendsNotificationWhenIndexChanges() {
        /// given
        let notificationExpectation = expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: nil)
        
        /// when
        sut.nextDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testDataManagerNotifcationIsIndexZeroIsFalse() {
        /// given
        let handler = { (notification: Notification) -> Bool in
            guard let isIndexZero = notification.userInfo?[DateSelector.isFirstDateSelectedKey] as? Bool
                else { return false }
        
            if isIndexZero {
                return false
            } else {
                return true
            }
        }
        
        let notificationExpectation = expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: handler)
        
        /// when
        sut.nextDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testDataManagerNotifcationIsIndexZeroIsTrue() {
        /// given
        sut.nextDate()
        
        let handler = { (notification: Notification) -> Bool in
            guard let isIndexZero = notification.userInfo?[DateSelector.isFirstDateSelectedKey] as? Bool
                else { return false }
        
            if isIndexZero {
                return true
            } else {
                return false
            }
        }
        
        let notificationExpectation = expectation(forNotification: .DateSelectorDateDidChange, object: nil, handler: handler)
        
        /// when
        sut.previousDate()
        
        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
}
