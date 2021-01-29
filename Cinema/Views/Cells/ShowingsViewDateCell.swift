//
//  ShowingsViewDateCell.swift
//  Cinema
//
//  Created by Marius on 2021-01-23.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

final class ShowingsViewDateCell: UICollectionViewCell {
    @IBOutlet weak var date: UILabel!

    override var isHighlighted: Bool {
        didSet {
            date.textColor = isHighlighted ? .tertiaryElement : .primaryElement
        }
    }
}
