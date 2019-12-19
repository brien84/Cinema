//
//  DailyViewController.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum DailyVCSegments: Int, Segments, CustomStringConvertible {
    case movies
    case showings

    // TODO: Localization?
    public var description: String {
        switch self {
        case .movies:
            return "Filmai"
        case .showings:
            return "Seansai"
        }
    }
}

///
final class DailyViewController: UIViewController, SegmentableContainer {
    
    private let movies: MovieManageable
    private var dates: DateManagerProtocol
    
    let containerView = UIView()
    let leftViewController = DateMovieVC()
    let rightViewController = DateShowingVC()
    
    private(set) lazy var segmentedControl: SegmentedControl = {
        let control = SegmentedControl(with: DailyVCSegments.self)
        control.delegate = self
        
        return control
    }()
    
    private lazy var leftDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Constants.Images.options
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        button.tintColor = Constants.Colors.blue
        self.navigationItem.leftBarButtonItem = button
        
        return button
    }()
    
    private lazy var rightDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Constants.Images.right
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        button.tintColor = Constants.Colors.blue
        self.navigationItem.rightBarButtonItem = button
        
        return button
    }()
    
    private var city: City {
        return UserDefaults.standard.readCity()
    }
    
    init(dateManager: DateManagerProtocol = DateManager(), movieManager: MovieManageable = MovieManager()) {
        self.dates = dateManager
        self.movies = movieManager
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = createSegmentableContainerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.Colors.light
        
        setupNotificationObservers()

        ///
        segmentedControl.selectedSegmentIndex = DailyVCSegments.showings.rawValue
        segmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
        enableControlElements(false)
        
        fetchMovies()
    }
    
    // MARK: - Setup Methods
        
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .DateManagerIndexDidChange, object: nil, queue: .main) { notification in
            self.updateLeftDateNavigationButtonAppearance(notification)
        }
        
        NotificationCenter.default.addObserver(forName: .OptionsVCCityDidChange, object: nil, queue: .main) { _ in
            self.updateDatasource()
        }
    }
    
    // MARK: - Model Methods
    
    private func fetchMovies() {
        movies.fetch(using: .shared) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.movieManagerDidFetchSuccessfully()
                case .failure(let error):
                    print("DateContainerVC.fetchMovies: \(error)")
                    self.movieManagerDidFetchWithError()
                }
            }
        }
    }

    private func movieManagerDidFetchSuccessfully() {
        enableControlElements(true)
        
        containerDisplayErrorLabel(nil)
        updateDatasource()
    }
    
    private func movieManagerDidFetchWithError() {
        containerDisplayErrorLabel(.network)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchMovies()
        }
    }
    
    private func updateDatasource() {
        switch segmentedControl.selectedSegmentIndex {
        case DailyVCSegments.movies.rawValue:
            leftViewController.datasource = movies.filterMovies(in: city, at: dates.selectedDate)
        case DailyVCSegments.showings.rawValue:
            rightViewController.datasource = movies.filterShowings(in: city, at: dates.selectedDate)
        default:
            return
        }
    }
    
    // MARK: - View Methods
    
    private func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    private func updateLeftDateNavigationButtonAppearance(_ notification: Notification) {
        guard let info = notification.userInfo as? [String: Bool] else { return }
        guard let isIndexZero = info[Constants.UserInfo.isIndexZero] else { return }
        leftDateNavigationButton.image = isIndexZero ? Constants.Images.options : Constants.Images.left
    }
    
    private func enableControlElements(_ enabled: Bool) {
        segmentedControl.isEnabled = enabled
        leftDateNavigationButton.isEnabled = enabled
        rightDateNavigationButton.isEnabled = enabled
    }

    // TODO: REFACTOR
    private func containerDisplayErrorLabel(_ error: DataError?) {
        if let label = containerView.subviews.first(where: { type(of: $0) == ErrorLabel.self }) {
            label.removeFromSuperview()
        }
        
        if let error = error {
            let label = ErrorLabel(frame: containerView.bounds, error: error)
            containerView.addSubview(label)
        }
    }
 
    // MARK: - Navigation Methods
    
    ///
    func segmentedControl(_ segmentedControl: SegmentedControl, didChange index: Int) {
        updateContainerViewBySegmentedControl(index)
        updateDatasource()
    }
    
    @objc private func handleDateNavigationButtonTap(_ sender: UIBarButtonItem) {
        switch true {
        case sender == leftDateNavigationButton:
            if leftDateNavigationButton.image == Constants.Images.options {
                navigationController?.pushViewController(OptionsVC(), animated: true)
                return
            } else {
                dates.decreaseDate()
            }
        case sender == rightDateNavigationButton:
            dates.increaseDate()
        default:
            return
        }
        
        updateDatasource()
        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
    }
}
