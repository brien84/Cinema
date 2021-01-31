//
//  SettingsViewCell.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class SettingsViewCell: UITableViewCell {
    @IBOutlet weak var city: CustomFontLabel!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                city.isHighlighted = true
            } else {
                city.isHighlighted = false
            }
        }
    }
}
