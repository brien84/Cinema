//
//  ContainerVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class ContainerVCTests: XCTestCase {
    
    var sut: ContainerVC!

    override func setUp() {
        sut = ContainerVC(leftVC: MockViewController(id: 0), rightVC: MockViewController(id: 1), segments: MockSegments.self)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testBackgroundColorIsLight() {
        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertEqual(sut.view.backgroundColor, Constants.Colors.light)
    }
    
    func testSegmentedControlIsNotNil() {
        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertNotNil(sut.controlSelectedIndex)
    }
    
    func testContainerVCShowsLeftViewController() {
        /// when
        sut.loadViewIfNeeded()
        sut.controlSelectedIndex = 0
        
        /// then
        guard let vc = sut.children.first as? MockViewController else { return XCTFail() }
        XCTAssertEqual(vc.id, 0)
    }
    
    func testContainerVCShowsRightViewController() {
        /// when
        sut.loadViewIfNeeded()
        sut.controlSelectedIndex = 1
        
        /// then
        guard let vc = sut.children.first as? MockViewController else { return XCTFail() }
        XCTAssertEqual(vc.id, 1)
    }
    
    // MARK: - Test Helpers
    
    private class MockViewController: UIViewController {
        let id: Int
        
        init(id: Int) {
            self.id = id
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private enum MockSegments: Int, CaseIterable {
        case one
        case two
    }
}
