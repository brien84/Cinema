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
    
    //
    private let movieVC = DateMovieVC()
    private let showingsVC = DateShowingVC()
    //
    
    init() {
        super.init(leftVC: movieVC, rightVC: showingsVC, segments: DateVCSegments.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: NAMES IN CONSTANTS
        let rightButton = NavigationButton(Constants.Images.right)
        rightButton.delegate = self
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = NavigationButton(Constants.Images.options)
        leftButton.delegate = self
        self.navigationItem.leftBarButtonItem = leftButton
        
        updateNavigationTitle(with: dates.selectedDate.asString(excludeTime: true))
        
        control.selectedSegmentIndex = 1
        indexChanged(to: control.selectedSegmentIndex)
        
        NotificationCenter.default.addObserver(forName: .didFinishFetching, object: nil, queue: .main) { notification in
            self.movieManagerDidFinishFetching()
        }
        
        NotificationCenter.default.addObserver(forName: .dateIndexDidChange, object: nil, queue: .main) { notification in
            self.updateNavButtonAppearance(notification)
        }
    }
    
    private func updateNavButtonAppearance(_ notification: Notification) {
        
        guard let info = notification.userInfo as? [String: Bool] else { return }
        
        // TODO: Fix hardcode
        guard let isIndexZero = info["isIndexZero"]  else { return }
        
        guard let navButton = navigationItem.leftBarButtonItems?.first else { return }
        
        navButton.title = isIndexZero ? "O" : "-"
    }
    
    private func movieManagerDidFinishFetching() {
        updateDatasource()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    private func updateDatasource() {
        if control.selectedSegmentIndex == 0 {
            if let vc = self.children.first as? DateMovieVC {
                vc.datasource = movies.getMovies(shownAt: dates.selectedDate)
            }
        }
        if control.selectedSegmentIndex == 1 {
            if let vc = self.children.first as? DateShowingVC {
                vc.datasource = movies.getShowings(shownAt: dates.selectedDate)
            }
        }
    }
    
}

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
