//
//  DateContainerCell.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DateContainerCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var poster: NetworkImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = Constants.Colors.lightBlue
        self.selectedBackgroundView = bgColorView

        self.backgroundColor = Constants.Colors.light
        
        title.textColor = Constants.Colors.dark
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0)!
        title.numberOfLines = 0
        
        originalTitle.textColor = Constants.Colors.gray
        originalTitle.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 16.0)!
        originalTitle.numberOfLines = 0
        
        leftLabel.textColor = Constants.Colors.dark
        leftLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        
        rightLabel.textColor = Constants.Colors.dark
        rightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
    }
}
