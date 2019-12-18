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

    // TODO: Localization?
    public var description: String {
        switch self {
        case .about:
            return "Apie"
        case .showings:
            return "Seansai"
        }
    }
}

///
final class MovieViewController: UIViewController, SegmentableContainer {
    
    private let movie: Movie

    let containerView = UIView()
   
    private(set) lazy var leftViewController: MovieViewVC = {
        let controller = MovieViewVC()
        controller.movie = movie

        return controller
    }()
    
    private(set) lazy var rightViewController: MovieShowingVC = {
        let controller = MovieShowingVC()
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
        self.view = createSegmentableContainerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.Colors.light
        
        ///
        segmentedControl.selectedSegmentIndex = MovieVCSegments.about.rawValue
        segmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
        self.navigationItem.title = movie.title
    }
}
