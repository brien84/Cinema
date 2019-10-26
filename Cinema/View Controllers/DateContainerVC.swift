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
class DateContainerVC: ContainerVC {
    
    private let dates = DateManager()
    private let movies = MovieManager()
    
    private let movieVC = DateMovieVC()
    private let showingsVC = DateShowingVC()
    
    private var city: City = {
        return UserDefaults.standard.readCity() ?? City.vilnius
    }()
    
    init() {
        super.init(leftVC: movieVC, rightVC: showingsVC, segments: DateContainerSegments.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup NavigationButtons
        let leftButton = NavigationButton(Constants.Images.options)
        leftButton.isEnabled = false
        leftButton.delegate = self
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = NavigationButton(Constants.Images.right)
        rightButton.isEnabled = false
        rightButton.delegate = self
        self.navigationItem.rightBarButtonItem = rightButton
        
        /// Setup NotificationCenter Observers
        NotificationCenter.default.addObserver(forName: .moviesDidFetchSuccessfully, object: nil, queue: .main) { notification in
            self.movieManagerDidFetchSuccessfully()
        }
        
        NotificationCenter.default.addObserver(forName: .moviesDidFetchWithError, object: nil, queue: .main) { notification in
            self.movieManagerDidFetchWithError()
        }
        
        NotificationCenter.default.addObserver(forName: .dateIndexDidChange, object: nil, queue: .main) { notification in
            self.updateNavButtonAppearance(notification)
        }
        
        NotificationCenter.default.addObserver(forName: .cityDidChange, object: nil, queue: .main) { notification in
            self.updateCity()
        }
        
        /// Methods called manually on first load
        movies.loadMovies()
        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
        updateCity()
        controlSelectedIndex = DateContainerSegments.showings.rawValue
    }
    
    private func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    private func updateDatasource() {
        if controlSelectedIndex == DateContainerSegments.movies.rawValue {
            if let vc = self.children.first as? DateMovieVC {
                vc.datasource = movies.getMovies(in: city, at: dates.selectedDate)
            }
        }
        
        if controlSelectedIndex == DateContainerSegments.showings.rawValue {
            if let vc = self.children.first as? DateShowingVC {
                vc.datasource = movies.getShowings(in: city, at: dates.selectedDate)
            }
        }
    }
    
    // MARK: - NotificationCenter Observer methods
    
    private func movieManagerDidFetchSuccessfully() {
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        self.toggleSegmentedControl(enabled: true)
        self.containerDisplayErrorLabel(nil)
        updateDatasource()
    }
    
    private func movieManagerDidFetchWithError() {
        self.toggleSegmentedControl(enabled: false)
        self.containerDisplayErrorLabel(.network)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.movies.loadMovies()
        }
    }
    
    private func updateNavButtonAppearance(_ notification: Notification) {
        guard let info = notification.userInfo as? [String: Bool] else { return }
        guard let isIndexZero = info[Constants.UserInfo.isIndexZero] else { return }
        guard let navButton = navigationItem.leftBarButtonItems?.first else { return }
        navButton.image = isIndexZero ? Constants.Images.options : Constants.Images.left
    }
    
    private func updateCity() {
        guard let city = UserDefaults.standard.readCity() else { fatalError("DateContainerVC.updateCity: City is nil!") }
        self.city = city
        updateDatasource()
    }
    
    // MARK: - SegmentedControlDelegate
    
    override func indexChanged(to newIndex: Int){
        super.indexChanged(to: newIndex)
        updateDatasource()
    }
}

extension DateContainerVC: NavigationButtonDelegate {
    func buttonTap(_ sender: NavigationButton) {
        
        if navigationItem.leftBarButtonItems?.contains(sender) ?? false {
            if sender.image == Constants.Images.options {
                navigationController?.pushViewController(OptionsVC(), animated: true)
                return
            } else {
                dates.decreaseDate()
            }
        }
        
        if navigationItem.rightBarButtonItems?.contains(sender) ?? false {
            dates.increaseDate()
        }
        
        updateDatasource()
        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
    }
}
