//
//  DateContainerVC.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DateContainerVC: ContainerVC {
    
    private let dates = DateManager()
    private let movies = MovieManager()
    
    private let movieVC = DateMovieVC()
    private let showingsVC = DateShowingVC()
    
    private var city: City = {
        return UserDefaults.standard.readCity() ?? City.vilnius
    }()
    
    init() {
        super.init(leftVC: movieVC, rightVC: showingsVC, segments: DateVCSegments.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup NavigationButtons
        let rightButton = NavigationButton(Constants.Images.right)
        rightButton.delegate = self
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = NavigationButton(Constants.Images.options)
        leftButton.delegate = self
        self.navigationItem.leftBarButtonItem = leftButton
        
        // Setup NotificationCenter Observers
        NotificationCenter.default.addObserver(forName: .didFinishFetching, object: nil, queue: .main) { notification in
            self.movieManagerDidFinishFetching()
        }
        
        NotificationCenter.default.addObserver(forName: .dateIndexDidChange, object: nil, queue: .main) { notification in
            self.updateNavButtonAppearance(notification)
        }
        
        NotificationCenter.default.addObserver(forName: .cityDidChange, object: nil, queue: .main) { notification in
            self.updateCity()
        }
        
        // Methods called manually on first load
        updateNavigationTitle(with: dates.selectedDate.asString(excludeTime: true))
        updateCity()
        controlSelectedIndex = DateVCSegments.showings.rawValue
    }
    
    private func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    private func updateDatasource() {
        if controlSelectedIndex == DateVCSegments.movies.rawValue {
            if let vc = self.children.first as? DateMovieVC {
                vc.datasource = movies.getMovies(in: city, at: dates.selectedDate)
            }
        }
        if controlSelectedIndex == DateVCSegments.showings.rawValue {
            if let vc = self.children.first as? DateShowingVC {
                vc.datasource = movies.getShowings(in: city, at: dates.selectedDate)
            }
        }
    }
    
    // MARK: - NotificationCenter Observer methods
    
    private func movieManagerDidFinishFetching() {
        updateDatasource()
        NotificationCenter.default.removeObserver(self)
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

// TODO: FIX THIS
extension DateContainerVC: NavigationButtonDelegate {
    func buttonTap(_ sender: NavigationButton) {
        if navigationItem.leftBarButtonItems?.contains(sender) ?? false {
            
            if sender.image == Constants.Images.options {
                let optionsVC = OptionsVC()
                navigationController?.pushViewController(optionsVC, animated: true)
                return
            } else {
                dates.decreaseDate()
                updateDatasource()
            }
        }
        
        if navigationItem.rightBarButtonItems?.contains(sender) ?? false {
            dates.increaseDate()
            updateDatasource()
        }
        
        updateNavigationTitle(with: dates.selectedDate.asString(excludeTime: true))
    }
}
