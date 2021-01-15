//
//  DateViewCell.swift
//  Cinema
//
//  Created by Marius on 2020-08-06.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DateViewCell: UITableViewCell {
    @IBOutlet weak var poster: NetworkImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var time: UILabel!

    @IBOutlet private weak var hide3DIcon: NSLayoutConstraint!

    var is3D = false {
        didSet {
            hide3DIcon.isActive = !is3D
        }
    }
}
