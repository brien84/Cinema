//
//  MovieVC.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

extension MovieVC: SegmentedControlDelegate {
    func segmentedControl(newIndex: Int) {
        
        switch newIndex {
        case MovieVCSegments.Apie.rawValue:
            updateContainer(with: movieVC)
        case MovieVCSegments.Seansai.rawValue:
            updateContainer(with: showingVC) //!!! TEMP
        default:
            return
        }
    }
}

class MovieVC: UIViewController {
    
    private weak var container: UIView!
    private weak var control: SegmentedControl!
    
    var movie: Movie!
    private let movieVC = MovieViewVC()
    private let showingVC = MovieViewShowingTableVC()
    
    override func loadView() {
        super.loadView()
        
        // SegmentedControl setup
        let segmentedControl = SegmentedControl(frame: .zero, segments: MovieVCSegments.self)
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
        movieVC.movie = movie
        showingVC.datasource = movie.showings.map { $0 }
    }
    
    // MARK: - View Container methods
    
    private func updateContainer(with viewController: UIViewController) {
        removeCurrentViewController()
        show(viewController)
    }
    
    private func show(_ viewController: UIViewController) {
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
