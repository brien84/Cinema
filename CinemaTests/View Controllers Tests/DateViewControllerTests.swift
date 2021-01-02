//
//  DateViewControllerTests.swift
//  CinemaTests
//
//  Created by Marius on 2020-12-30.
//  Copyright © 2020 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

final class DateViewControllerTests: XCTestCase {
    var sut: DateViewController!
    var dates: DateTrackerStub!
    var fetcher: MovieFetcherStub!

    override func setUpWithError() throws {
        dates = DateTrackerStub()
        fetcher = MovieFetcherStub()
        setupSUT()
    }

    override func tearDownWithError() throws {
        dates = nil
        fetcher = nil
        sut = nil
    }

    func testTableViewDatasourceCount() {
        sutLoadViewIfNeeded()

        waitForUIUpdate()

        XCTAssertGreaterThan(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 0)
    }

    func testTableViewCellsHaveCorrectValuesSet() {
        let testTitle = "testTitle"
        let testOriginalTitle = "testOriginalTitle"
        let testURL = URL(string: "https://google.com")!
        let testVenue = "testVenue"
        let testTime = Date.today
        let test3D = true
        let movie = Movie.create(testTitle, testOriginalTitle, "", "", "", [], "", testURL, [])
        let showing = Showing.create(.vilnius, testTime, testVenue, test3D)
        showing.parentMovie = movie
        fetcher.showings = [showing]

        sutLoadViewIfNeeded()

        waitForUIUpdate()

        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DateShowingCell

        XCTAssertEqual(cell?.title.text, testTitle)
        XCTAssertEqual(cell?.originalTitle.text, testOriginalTitle)
        XCTAssertEqual(cell?.poster?.url, testURL)
        XCTAssertEqual(cell?.venue.text, testVenue)
        XCTAssertEqual(cell?.time.text, testTime.asString(.timeOfDay))
        XCTAssertEqual(cell?.is3D, test3D)
    }

    // MARK: Test Helpers

    func setupSUT() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            sut = storyboard.instantiateViewController(identifier: "dateVC") { [self] coder in
                DateViewController(coder: coder, dates: dates, fetcher: fetcher)
            }
        } else {
            fatalError("iOS13+ required.")
        }
    }

    func sutLoadViewIfNeeded() {
        sut.loadViewIfNeeded()

        // Remove `DateContainerViewController` to prevent `UIViewControllerHierarchyInconsistency` error.
        sut.children.forEach { $0.removeFromParent() }
    }

    func waitForUIUpdate() {
        let expectation = self.expectation(description: "Wait for UI to update.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3.0)
    }

    class DateTrackerStub: DateSelectable {
        var current: Date = Date()
        var isFirst: Bool = false
        var isLast: Bool = false

        func previous() { }
        func next() { }
    }

    class MovieFetcherStub: MovieFetching {
        var isFetchSuccessful = true
        var movies = [Movie.create("", "", "", "", "", [], "", URL(string: "https://google.com")!, [])]
        var showings = [Showing.create(.vilnius, Date(), "", true)]

        func getMovies(at date: Date) -> [Movie] {
            movies
        }

        func getShowings(at date: Date) -> [Showing] {
            showings
        }

        func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> Void) {
            if isFetchSuccessful {
                completion(.success(()))
            } else {
                completion(.failure(TestError.testError))
            }
        }
    }

    enum TestError: Error {
        case testError
    }
}
