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
        
        let bottomConstraint = movieView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            movieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            movieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomConstraint
        ])
        
        self.movieView = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            //movieView.title.text = movie.title
           // movieView.originalTitle.text = movie.originalTitle
            movieView.plot.text = movie.plot
            movieView.country.text = movie.country
            movieView.genre.text = movie.genre
            movieView.rated.text = movie.ageRating
            movieView.released.text = movie.releaseDate
            movieView.runtime.text = movie.duration
        }
    }
}
