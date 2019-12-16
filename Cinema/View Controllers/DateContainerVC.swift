//
//  DateContainerVC.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Container ViewController displaying DateMovieVC and ShowingVC
/// with Date selection in NavigationController.
///
/// According to selected date, DateContainerVC gets Movies from
/// MovieManager and sets datasource to child ViewControllers.
final class DateContainerVC: ContainerVC {
    
    private var dates: DateManagerProtocol!
    private var movies: MovieManagerProtocol!
    
    private let movieVC = DateMovieVC()
    private let showingVC = DateShowingVC()
    
    private var city: City {
        return UserDefaults.standard.readCity()
    }
    
    private lazy var leftDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Constants.Images.options
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        button.tintColor = Constants.Colors.blue
        
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var rightDateNavigationButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Constants.Images.right
        button.target = self
        button.action = #selector(handleDateNavigationButtonTap)
        button.tintColor = Constants.Colors.blue
        
        button.isEnabled = false
        
        return button
    }()
    
    init(dateManager: DateManagerProtocol = DateManager(), movieManager: MovieManagerProtocol = MovieManager()) {
        super.init(leftVC: movieVC, rightVC: showingVC, segments: DateContainerSegments.self)
        
        self.dates = dateManager
        self.movies = movieManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = leftDateNavigationButton
        self.navigationItem.rightBarButtonItem = rightDateNavigationButton

        setupNotificationObservers()

        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
        controlSelectedIndex = DateContainerSegments.showings.rawValue
        
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
    
    // MARK: - Fetching Methods
    
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
        leftDateNavigationButton.isEnabled = true
        rightDateNavigationButton.isEnabled = true
        
        self.toggleSegmentedControl(enabled: true)
        self.containerDisplayErrorLabel(nil)
        updateDatasource()
    }
    
    private func movieManagerDidFetchWithError() {
        self.toggleSegmentedControl(enabled: false)
        self.containerDisplayErrorLabel(.network)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchMovies()
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
    
    // MARK: - Model Methods
    
    private func updateDatasource() {
        switch controlSelectedIndex {
            
        case DateContainerSegments.movies.rawValue:
            movieVC.datasource = movies.getMovies(in: city, at: dates.selectedDate)
            
        case DateContainerSegments.showings.rawValue:
            showingVC.datasource = movies.getShowings(in: city, at: dates.selectedDate)
            
        default:
            break
        }
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
    
    // MARK: - SegmentedControlDelegate
    
    override func indexChanged(to newIndex: Int){
        super.indexChanged(to: newIndex)
        updateDatasource()
    }
}
