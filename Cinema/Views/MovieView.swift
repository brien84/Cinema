//
//  MovieView.swift
//  Cinema
//
//  Created by Marius on 28/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ageRatingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var poster: NetworkImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MovieView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        separator.backgroundColor = Constants.Colors.blue
        setupStaticOutlets()
        setupDynamicOutlets()
    }
    
    private func setupStaticOutlets() {
        durationLabel.text = "Trukmė"
        durationLabel.textColor = Constants.Colors.gray
        durationLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
        
        ageRatingLabel.text = "Cenzas"
        ageRatingLabel.textColor = Constants.Colors.gray
        ageRatingLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
        
        genreLabel.text = "Žanras"
        genreLabel.textColor = Constants.Colors.gray
        genreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
        
        countryLabel.text = "Sukurta"
        countryLabel.textColor = Constants.Colors.gray
        countryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
        
        releaseDateLabel.text = "Išleista"
        releaseDateLabel.textColor = Constants.Colors.gray
        releaseDateLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
    }
    
    private func setupDynamicOutlets() {
        duration.textColor = Constants.Colors.dark
        duration.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        ageRating.textColor = Constants.Colors.dark
        ageRating.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        genre.textColor = Constants.Colors.dark
        genre.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        genre.numberOfLines = 0
        
        country.textColor = Constants.Colors.dark
        country.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        releaseDate.textColor = Constants.Colors.dark
        releaseDate.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        plot.textColor = Constants.Colors.dark
        plot.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        genre.numberOfLines = 0
    }
}
