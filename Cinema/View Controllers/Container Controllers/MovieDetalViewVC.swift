//
//  MovieDetalViewVC.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class MovieDetalViewVC: UIViewController {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let movieView = MovieDetailView()

        self.view = setup(movieView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.Colors.light
    }
    
    private func setup(_ view: MovieDetailView) -> MovieDetailView {
        view.poster.url = movie.poster?.toURL()
        view.year.text = movie.year
        view.ageRating.text = movie.ageRating
        view.duration.text = movie.duration
        view.plot.text = movie.plot
        view.genres = movie.genre
        
        return view
    }
}
