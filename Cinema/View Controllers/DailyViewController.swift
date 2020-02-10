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

    var description: String {
        switch self {
        case .movies:
            return "Filmai"
        case .showings:
            return "Seansai"
        }
    }
}

final class DailyViewController: UIViewController, SegmentableContainer {
    
    var movies = [Movie]()

    private var dates: DateSelectable
    
    let containerView = UIView()
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
    
    private lazy var loadingView = LoadingView(frame: containerView.bounds)
    
    private var city: City {
        return UserDefaults.standard.readCity()
    }
    
    init(dateManager: DateSelectable = DateSelector()) {
        self.dates = dateManager
        
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
        
        view.backgroundColor = .transparentBlackC
        
        setupNotificationObservers()

        ///
        segmentedControl.selectedSegmentIndex = DailyVCSegments.showings.rawValue
        segmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
        enableControlElements(false)
        
        DispatchQueue.main.async {
            self.containerView.addSubview(self.loadingView)
        }
        
        fetchMovies()
    }
    
    // MARK: - Setup Methods
        
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .DateSelectorDateDidChange, object: nil, queue: .main) { _ in
            self.handleDateChange()
        }
        
        NotificationCenter.default.addObserver(forName: .OptionsCityDidChange, object: nil, queue: .main) { _ in
            self.updateDatasource()
        }
    }
    
    private func updateDatasource() {
        switch segmentedControl.selectedSegmentIndex {
        case DailyVCSegments.movies.rawValue:
            leftViewController.datasource = filterMovies(in: city, at: dates.selectedDate)
        case DailyVCSegments.showings.rawValue:
            rightViewController.datasource = filterShowings(in: city, at: dates.selectedDate)
        default:
            return
        }
    }
    
    // MARK: - View Methods
    
    private func updateNavigationTitle(with title: String) {
        let textTransition = CATransition()
        textTransition.duration = 0.3
        textTransition.type = .fade
        navigationController?.navigationBar.layer.add(textTransition, forKey: "textFade")

        navigationItem.title = title
    }
    
    private func enableControlElements(_ enabled: Bool) {
        segmentedControl.isEnabled = enabled
        leftDateNavigationButton.isEnabled = enabled
        rightDateNavigationButton.isEnabled = enabled
    }
 
    // MARK: - Navigation Methods
    
    ///
    func segmentedControl(_ segmentedControl: SegmentedControl, didChange index: Int) {
        updateContainerViewBySegmentedControl(index)
        updateDatasource()
    }
    
    private func handleDateChange() {
        leftDateNavigationButton.image = dates.isFirstDateSelected ? .options : .left
        rightDateNavigationButton.isEnabled = dates.isLastDateSelected ? false : true

        updateNavigationTitle(with: dates.selectedDate.asString(format: .monthNameAndDay))
        updateDatasource()
    }
    
    @objc private func handleDateNavigationButtonTap(_ sender: UIBarButtonItem) {
        
        let directionToRight: Bool
        
        switch sender {
        case leftDateNavigationButton:
            if dates.isFirstDateSelected {
                navigationController?.pushViewController(OptionsViewController(), animated: true)
                return
            } else {
                dates.previousDate()
                directionToRight = false
            }
        case rightDateNavigationButton:
            dates.nextDate()
            directionToRight = true
        default:
            return
        }
        
        guard let snapShotView = containerView.snapshotView(afterScreenUpdates: false) else { return }
        view.addSubview(snapShotView)
        view.sendSubviewToBack(snapShotView)

        containerView.frame.origin.x += directionToRight ? containerView.frame.width : -containerView.frame.width

        UIView.transition(with: containerView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.containerView.frame.origin.x = 0
            snapShotView.frame.origin.x += directionToRight ? -snapShotView.frame.width : snapShotView.frame.width
            snapShotView.alpha = 0.2
        }, completion: { _ in
            snapShotView.removeFromSuperview()
        })
    }
}

extension DailyViewController: MovieManageable {
    
    private func fetchMovies() {
        fetch(using: .shared) { result in
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
            self.loadingView.removeFromSuperview()
            self.enableControlElements(true)
            self.updateDatasource()
        }
    }
    
    private func didFetchWithError() {
        DispatchQueue.main.async {
            self.loadingView.hide(networkError: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMovies()
        }
    }
}
