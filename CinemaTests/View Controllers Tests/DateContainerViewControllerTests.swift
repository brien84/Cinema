//
//  DateContainerViewControllerTests.swift
//  CinemaTests
//
//  Created by Marius on 2021-01-13.
//  Copyright © 2021 Marius. All rights reserved.
//

import XCTest
@testable import iKinas

final class DateContainerViewControllerTests: XCTestCase {
    var sut: DateContainerViewController!
    var fakeDateVC: DateViewController!

    override func setUpWithError() throws {
        setupSUT()
        setupFakeDateVC()
        fakeDateVC.delegate = sut
    }

    override func tearDownWithError() throws {
        sut = nil
        fakeDateVC = nil
    }

    func testCollectionViewDatasourceCount() throws {
        let movie = Movie.create("", "", "", "", "", [], "", URL(string: "https://google.com")!, [])
        fakeDateVC.delegate?.dateVC(fakeDateVC, didUpdate: [movie])

        sut.loadViewIfNeeded()

        XCTAssertGreaterThan(sut.collectionView(sut.collectionView, numberOfItemsInSection: 0), 0)
    }

    func testCollectionViewCellsHaveCorrectValuesSet() {
        let title = "testTitle"
        let url = URL(string: "https://google.com")!
        let movie = Movie.create(title, "", "", "", "", [], "", url, [])
        fakeDateVC.delegate?.dateVC(fakeDateVC, didUpdate: [movie])

        sut.loadViewIfNeeded()

        let cell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? DateContainerViewCell

        XCTAssertEqual(cell?.title.text, title)
        XCTAssertEqual(cell?.poster.url, url)
    }

    // MARK: Test Helpers

    func setupSUT() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "dateContainerVC") as? DateContainerViewController
    }

    func setupFakeDateVC() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            fakeDateVC = storyboard.instantiateViewController(identifier: "dateVC") { coder in
                DateViewController(coder: coder, dates: FakeSelector(), fetcher: FakeFetcher())
            }
        } else {
            fatalError("iOS13+ required.")
        }
    }

    class FakeFetcher: MovieFetching {
        func getMovies(at date: Date) -> [Movie] { [] }
        func getShowings(at date: Date) -> [Showing] { [] }
        func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> Void) { }
    }

    class FakeSelector: DateTracking {
        var selected: Date = Date()
        var isFirst: Bool = false
        var isLast: Bool = false

        func previous() { }
        func next() { }
    }
}
