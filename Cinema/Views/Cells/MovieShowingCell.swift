//
//  MovieShowingCell.swift
//  Cinema
//
//  Created by Marius on 18/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieShowingCell: UITableViewCell {

    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = Constants.Colors.lightBlue
        self.selectedBackgroundView = bgColorView

        venue.textColor = Constants.Colors.dark
        venue.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        date.textColor = Constants.Colors.dark
        date.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!

        time.textColor = Constants.Colors.dark
        time.font = UIFont(name: "HelveticaNeue-Medium", size: 36.0)!
    }
}
