//
//  DailyViewController.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class DailyViewController: UIViewController {

    private let dateSelector: DateSelectable
    private let movieManager: MovieManageable

    let containerView = ContainerView()

    let leftViewController = DailyMoviesVC(collectionViewLayout: UICollectionViewFlowLayout())
    let rightViewController = DailyShowingsVC()

    private(set) lazy var segmentedControl: SegmentedControl = {
        let control = SegmentedControl(with: DailyVCSegments.self)
        control.delegate = self

        return control
    }()

    private lazy var leftDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .options
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        self.navigationItem.leftBarButtonItem = button

        return button
    }()

    private lazy var rightDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .right
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        self.navigationItem.rightBarButtonItem = button

        return button
    }()

    private var city: City {
        return UserDefaults.standard.readCity()
    }

    init(dateSelector: DateSelectable = DateSelector(), movieManager: MovieManageable = MovieManager()) {
        self.dateSelector = dateSelector
        self.movieManager = movieManager

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = constructSegmentableContainerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .transparentBlackC

        setupNotificationObservers()

        updateNavigationTitle(with: dateSelector.current.asString(format: .monthNameAndDay))
        segmentedControl.setSelectedSegmentIndex(DailyVCSegments.showings.rawValue)

        fetchMovies()
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .DateSelectorDateDidChange, object: nil, queue: .main) { _ in
            self.handleDateChange()
        }

        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { _ in
            self.updateDatasource()
        }
    }

    private func updateNavigationTitle(with title: String) {
        let textTransition = CATransition()
        textTransition.duration = 0.3
        textTransition.type = .fade
        navigationController?.navigationBar.layer.add(textTransition, forKey: "textFade")

        navigationItem.title = title
    }

    private func updateDatasource() {
        leftViewController.datasource = movieManager.filterMovies(in: city, at: dateSelector.current)
        rightViewController.datasource = movieManager.filterShowings(in: city, at: dateSelector.current)
    }

    private func handleDateChange() {
        leftDateNavigationButton.image = dateSelector.isFirst ? .options : .left
        rightDateNavigationButton.isEnabled = dateSelector.isLast ? false : true

        updateNavigationTitle(with: dateSelector.current.asString(format: .monthNameAndDay))
        updateDatasource()
    }

    @objc private func handleDateNavigationButtonTap(_ sender: UIBarButtonItem) {
        switch sender {

        case leftDateNavigationButton:
            if dateSelector.isFirst {
                navigationController?.pushViewController(OptionsViewController(), animated: true)
                return
            } else {
                dateSelector.previous()
                containerView.slideIn(from: .left)
            }

        case rightDateNavigationButton:
            dateSelector.next()
            containerView.slideIn(from: .right)

        default:
            return
        }
    }

    private func toggleControlElements(_ enabled: Bool) {
        segmentedControl.isEnabled = enabled
        leftDateNavigationButton.isEnabled = enabled
        rightDateNavigationButton.isEnabled = enabled
    }

    // MARK: - Movie Fetching:

    private func fetchMovies() {
        toggleControlElements(false)
        containerView.startLoading()

        movieManager.fetch(using: .shared) { result in
            switch result {

            case .success:
                self.didFetchSuccessfully()

            case .failure(let error):
                print("fetchMovies: \(error)")
                self.didFetchWithError()
            }
        }
    }

    private func didFetchSuccessfully() {
        DispatchQueue.main.async {
            self.updateDatasource()
            self.containerView.stopLoading()
            self.toggleControlElements(true)
        }
    }

    private func didFetchWithError() {
        DispatchQueue.main.async {
            self.containerView.displayNetworkError()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMovies()
        }
    }
}

extension DailyViewController: SegmentableContainer {

    private enum DailyVCSegments: Int, Segments, CustomStringConvertible {
        case movies
        case showings

        var description: String {
            switch self {
            case .movies:
                return "Filmai"
            case .showings:
                return "Seansai"
            }
        }
    }

}

extension UIImage {
    static let options = UIImage(named: "options")!
    static let left = UIImage(named: "arrowLeft")!
    static let right = UIImage(named: "arrowRight")!
}
