//
//  MovieViewVC.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class MovieViewVC: UIViewController {
    
    private let movie: Movie
    private var movieView: MovieDetailView!
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let movieView = Bundle.main.loadNibNamed("MovieDetailView", owner: nil, options: nil)?[0] as! MovieDetailView
        
        self.movieView = movieView
        self.view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieView.poster.url = movie.poster?.toURL()
        movieView.duration.text = movie.duration
        movieView.ageRating.text = movie.ageRating
        movieView.genre.text = movie.genre
        movieView.releaseDate.text = movie.releaseDate
        movieView.plot.text = movie.plot
    }
}
