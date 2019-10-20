//
//  OptionsCell.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class OptionsCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = Constants.Colors.light
        self.accessoryView?.tintColor = Constants.Colors.blue
        
        title.textColor = Constants.Colors.dark
        title.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
    }
}
