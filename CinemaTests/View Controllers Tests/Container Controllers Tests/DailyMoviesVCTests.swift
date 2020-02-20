//
//  DailyMoviesVCTests.swift
//  CinemaTests
//
//  Created by Marius on 15/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Cinema

class DailyMoviesVCTests: XCTestCase {

    var sut: DailyMoviesVC!

    override func setUp() {
        sut = DailyMoviesVC(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func tearDown() {
        sut = nil
    }

    func testCollectionViewRegistersCell() {
        // given
        let reuseIdentifier = "Cell"

        // when
        _ = sut.view

        // then
        guard let nibs = sut.collectionView.value(forKey: "_cellClassDict") as? [String: Any] else {
            return XCTFail("nibs dictionary is nil!")
        }

        XCTAssertTrue(nibs.contains { $0.key == reuseIdentifier })
    }

    func testCollectionViewTopContentInsetIsGreaterThanZero() {
        // when
        _ = sut.view

        // then
        XCTAssertGreaterThan(sut.collectionView.contentInset.top, 0)
    }

    func testCollectionViewBackgroundColorIsDark() {
        // when
        _ = sut.view

        // then
        XCTAssertEqual(sut.collectionView.backgroundColor, .darkC)
    }

    func testCollectionViewHasCorrectNumberOfItems() {
        // given
        let moviesCount = movies.count
        sut.datasource = movies

        // when
        _ = sut.view

        // then
        let itemsCount = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(itemsCount, moviesCount)
    }

    func testCollectionViewBackgroundViewIsErrorLabelWhenDatasourceEmpty() {
        // given
        sut.datasource = []

        // when
        _ = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)

        // then
        XCTAssertTrue(sut.collectionView.backgroundView is ErrorLabel)
    }

    func testCollectionViewBackgroundViewIsNilWhenDatasourceIsNotEmpty() {
        // given
        sut.datasource = movies

        // when
        _ = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)

        // then
        XCTAssertNil(sut.collectionView.backgroundView)
    }

    func testCollectionViewCellsHaveCorrectValuesSet() {
        // given
        sut.datasource = movies

        // then
        for (index, movie) in sut.datasource.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            // swiftlint:disable:next force_cast
            let cell = sut.collectionView(sut.collectionView, cellForItemAt: indexPath) as! DailyMoviesCell

            XCTAssertEqual(cell.poster.url, movie.poster)
            XCTAssertEqual(cell.title.text, movie.title)
            XCTAssertEqual(cell.duration.text, movie.duration)
            XCTAssertEqual(cell.ageRating.text, movie.ageRating)
        }
    }

    func testSelectingCollectionViewItemOpensMovieViewController() {
        // given
        let parentVC = UIViewController()
        parentVC.addChild(sut)
        _ = UINavigationController(rootViewController: parentVC)

        sut.datasource = movies
        let indexPath = IndexPath(row: 0, section: 0)

        let expectation = self.expectation(description: "Wait for UI to update.")

        // when
        sut.collectionView(sut.collectionView, didSelectItemAt: indexPath)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.sut.parent?.navigationController?.topViewController is MovieViewController)
            expectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 3)
    }

    // MARK: TestHelper:

    private var movies: [Movie] {
        return TestHelper.generateMovies(movieCount: 5)
    }

}
