//
//  DateMovieCell.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DateMovieCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var poster: NetworkImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Constants.Colors.light
        
        title.textColor = Constants.Colors.dark
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0)!
        title.numberOfLines = 0
        
        originalTitle.textColor = Constants.Colors.darkGray
        originalTitle.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 16.0)!
        originalTitle.numberOfLines = 0
        
        duration.textColor = Constants.Colors.dark
        duration.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        ageRating.textColor = Constants.Colors.dark
        ageRating.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
    }
}
