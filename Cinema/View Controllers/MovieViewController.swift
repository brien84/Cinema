//
//  MovieViewController.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {

    private let movie: Movie

    let containerView = ContainerView()
    private(set) lazy var leftViewController = MovieDetailViewVC(movie: movie)

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
        view = constructSegmentableContainerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .transparentBlackC

        navigationItem.title = movie.title

        segmentedControl.setSelectedSegmentIndex(MovieVCSegments.about.rawValue)
    }
}

extension MovieViewController: SegmentableContainer {

    private enum MovieVCSegments: Int, Segments, CustomStringConvertible {
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

}
