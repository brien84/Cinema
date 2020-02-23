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
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
}
