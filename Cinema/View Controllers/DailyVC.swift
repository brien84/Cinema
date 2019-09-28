//
//  DailyVC.swift
//  Cinema
//
//  Created by Marius on 24/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension DailyVC: SegmentedControlDelegate {
    func segmentedControl(newIndex: Int) {
        if newIndex == DailyVCSegments.Filmai.rawValue {
            updateContainer(with: movieVC)
            updateDatasource()
        }
        if newIndex == DailyVCSegments.Seansai.rawValue {
            updateContainer(with: showingVC)
            updateDatasource()
        }
    }
}

extension DailyVC: NavigationButtonDelegate {
    func buttonTap(_ sender: NavigationButton) {
        
        if navigationItem.leftBarButtonItems?.contains(sender) ?? false {
            dateManager.decreaseDate()
            updateDatasource()
        }
        
        if navigationItem.rightBarButtonItems?.contains(sender) ?? false {
            dateManager.increaseDate()
            updateDatasource()
        }
        
        updateNavigationTitle(with: dateManager.selectedDate.asString(excludeTime: true))
    }
}

class DailyVC: UIViewController {
    private let dateManager = DateManager()
    private let movieManager = MovieManager()
    
    private weak var container: UIView!
    private weak var control: SegmentedControl!
    
    private lazy var movieVC: MovieTableVC = {
        let movieVC = MovieTableVC(style: .plain)
        return movieVC
    }()
    
    private lazy var showingVC: ShowingTableVC = {
        let showingVC = ShowingTableVC(style: .plain)
        return showingVC
    }()

    override func loadView() {
        super.loadView()
        
        // SegmentedControl setup
        let segmentedControl = SegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
        
        segmentedControl.delegate = self
        self.control = segmentedControl

        // Container View setup
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.container = container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let rightButton = NavigationButton("+")
        rightButton.delegate = self
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = NavigationButton("-")
        leftButton.delegate = self
        self.navigationItem.leftBarButtonItem = leftButton
        
        updateNavigationTitle(with: dateManager.selectedDate.asString(excludeTime: true))
        
        control.selectedSegmentIndex = DailyVCSegments.Seansai.rawValue
        segmentedControl(newIndex: control.selectedSegmentIndex)
    }
    
    private func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    private func updateDatasource() {
        if control.selectedSegmentIndex == DailyVCSegments.Filmai.rawValue {
            if let vc = self.children.first as? MovieTableVC {
                vc.datasource = movieManager.getMovies(shownAt: dateManager.selectedDate)

            }
        }
        if control.selectedSegmentIndex == DailyVCSegments.Seansai.rawValue {
            if let vc = self.children.first as? ShowingTableVC {
                vc.datasource = movieManager.getShowings(shownAt: dateManager.selectedDate)
            }
        }
    }
    
    // MARK: - View Container methods
    
    private func updateContainer(with viewController: UITableViewController) {
        removeCurrentViewController()
        show(viewController)
    }

    private func show(_ viewController: UITableViewController) {
        self.addChild(viewController)
        viewController.view.frame = self.container.bounds
        self.container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func removeCurrentViewController() {
        if let viewController = self.children.first {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}
