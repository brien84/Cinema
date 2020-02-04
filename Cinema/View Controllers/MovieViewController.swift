//
//  MovieViewController.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum MovieVCSegments: Int, Segments, CustomStringConvertible {
    case about
    case showings

    var description: String {
        switch self {
        case .about:
            return "Apie"
        case .showings:
            return "Seansai"
        }
    }
}

final class MovieViewController: UIViewController, SegmentableContainer {
    
    private let movie: Movie

    let containerView = UIView()
   
    private(set) lazy var leftViewController: MovieDetailViewVC = {
        let controller = MovieDetailViewVC(movie: movie)

        return controller
    }()
    
    private(set) lazy var rightViewController: MovieShowingsVC = {
        let controller = MovieShowingsVC()
        let city = UserDefaults.standard.readCity()
        controller.datasource = movie.getShowings(in: city)

        return controller
    }()
    
    private(set) lazy var segmentedControl: SegmentedControl = {
        let control = SegmentedControl(with: MovieVCSegments.self)
        control.delegate = self

        return control
    }()
    
    init(with movie: Movie) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = createSegmentableContainerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .transparentBlackC
        
        ///
        segmentedControl.selectedSegmentIndex = MovieVCSegments.about.rawValue
        segmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
        navigationItem.title = movie.title
    }
}
