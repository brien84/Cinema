//
//  ShowingsViewTimeCell.swift
//  Cinema
//
//  Created by Marius on 2021-01-24.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

final class ShowingsViewTimeCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var venue: UILabel!

    @IBOutlet private weak var hide3DIcon: NSLayoutConstraint!

    var is3D = false {
        didSet {
            hide3DIcon.isActive = !is3D
        }
    }
}
