//
//  MovieViewVC.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieViewVC: UIViewController {
    
    var movie: Movie!
    private var movieView: MovieView!
    
    override func loadView() {
        super.loadView()
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("MovieView", owner: self, options: nil)
        guard let movieView = allViewsInXibArray?.first as? MovieView else { fatalError("Failed to init MovieView") }
        movieView.frame = .zero
        movieView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(movieView)
        
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            movieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            movieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            movieView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.movieView = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            movieView.title.text = movie.title
            movieView.originalTitle.text = movie.originalTitle
            movieView.plot.text = movie.plot
            movieView.country.text = movie.country
            movieView.genre.text = movie.genre
            movieView.rated.text = movie.rated
            movieView.released.text = movie.released
            movieView.runtime.text = movie.runtime
        }
    }    
}
