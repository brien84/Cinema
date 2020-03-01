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
        control.accessibilityIdentifier = "UI-DailyVCSegmented"
        control.delegate = self

        return control
    }()

    private lazy var optionsNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.accessibilityIdentifier = "UI-DailyVCOptionsButton"
        button.image = .options
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        self.navigationItem.leftBarButtonItem = button

        return button
    }()

    private lazy var leftDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.accessibilityIdentifier = "UI-DailyVCLeftButton"
        button.image = .left
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        self.navigationItem.leftBarButtonItem = button

        return button
    }()

    private lazy var rightDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.accessibilityIdentifier = "UI-DailyVCRightButton"
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
        segmentedControl.selectedSegment(DailyVCSegments.showings.rawValue)

        fetchMovies()
    }

    private func setupNotificationObservers() {
        // swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: .DateSelectorDateDidChange, object: nil, queue: .main) { _ in
            self.handleDateChange()
        }

        // swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { _ in
            self.updateDatasource()
        }
    }

    private func setupGestures() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
        leftRecognizer.direction = .left
        containerView.addGestureRecognizer(leftRecognizer)

        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
        rightRecognizer.direction = .right
        containerView.addGestureRecognizer(rightRecognizer)
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
        updateNavigationTitle(with: dateSelector.current.asString(format: .monthNameAndDay))
        updateDatasource()
    }

    @objc private func handleSwipeGestures(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {

        case .left:
            if !dateSelector.isLast {
                dateSelector.next()
                animateContainerView(from: .right)
            }

        case .right:
            if !dateSelector.isFirst {
                dateSelector.previous()
                animateContainerView(from: .left)
            }

        default:
            return
        }
    }

    @objc private func handleDateNavigationButtonTap(_ sender: UIBarButtonItem) {
        switch sender {

        case navigationItem.leftBarButtonItem:
            if dateSelector.isFirst {
                navigationController?.pushViewController(OptionsViewController(), animated: true)
                return
            } else {
                dateSelector.previous()
                animateContainerView(from: .left)
            }

        case navigationItem.rightBarButtonItem:
            dateSelector.next()
            animateContainerView(from: .right)

        default:
            return
        }
    }

    private func animateContainerView(from direction: UIView.AnimationDirection) {
        switch direction {

        case .left:
            leftDateNavigationButton.isEnabled = false
            containerView.slideIn(from: .left) {
                self.leftDateNavigationButton.isEnabled = true
                self.rightDateNavigationButton.isEnabled = self.dateSelector.isLast ? false : true
            }

        case .right:
            rightDateNavigationButton.isEnabled = false
            containerView.slideIn(from: .right) {
                self.rightDateNavigationButton.isEnabled = self.dateSelector.isLast ? false : true
            }
        }

        navigationItem.leftBarButtonItem = dateSelector.isFirst ? optionsNavigationButton : leftDateNavigationButton
    }

    private func toggleNavigationButtons(_ enabled: Bool) {
        leftDateNavigationButton.isEnabled = enabled
        optionsNavigationButton.isEnabled = enabled
        rightDateNavigationButton.isEnabled = enabled
    }

    private func toggleControlElements(_ enabled: Bool) {
        segmentedControl.isEnabled = enabled
        toggleNavigationButtons(enabled)
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
            self.setupGestures()
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

extension ContainerView {
    /// Animates `ContainerView` to slide into view from specified direction.
    fileprivate func slideIn(from direction: AnimationDirection, completion: @escaping () -> Void  = { }) {
        guard let superview = superview else { return }
        guard let snapshot = snapshotView(afterScreenUpdates: false) else { return }

        superview.addSubview(snapshot)
        superview.sendSubviewToBack(snapshot)

        let snapshotDestinationOriginX: CGFloat

        switch direction {
        case .left:
            frame.origin.x -= frame.width
            snapshotDestinationOriginX = snapshot.frame.origin.x + snapshot.frame.width
        case .right:
            frame.origin.x += frame.width
            snapshotDestinationOriginX = snapshot.frame.origin.x - snapshot.frame.width
        }

        UIView.transition(with: self, duration: 0.5, options: .curveEaseInOut, animations: {
            self.frame.origin.x = 0
            snapshot.frame.origin.x = snapshotDestinationOriginX
            snapshot.alpha = 0.2
        }, completion: { _ in
            snapshot.removeFromSuperview()
            completion()
        })
    }
}

extension UIImage {
    static let options = UIImage(named: "options")!
    static let left = UIImage(named: "arrowLeft")!
    static let right = UIImage(named: "arrowRight")!
}
