//
//  MovieContainerVC.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieContainerVC: ContainerVC {
    
    var movie: Movie!
    
    private let movieVC = MovieViewVC()
    private let showingVC = MovieShowingVC()
    
    private var city: City = {
        return UserDefaults.standard.readCity() ?? City.vilnius
    }()
    
    init() {
        super.init(leftVC: movieVC, rightVC: showingVC, segments: MovieContainerSegments.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        movieVC.movie = movie
        showingVC.datasource = movie.getShowings(in: city)
        controlSelectedIndex = MovieContainerSegments.about.rawValue
    }  
}
