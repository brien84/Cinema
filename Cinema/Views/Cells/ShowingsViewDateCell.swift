//
//  ShowingsViewDateCell.swift
//  Cinema
//
//  Created by Marius on 2021-01-23.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

final class ShowingsViewDateCell: UICollectionViewCell {
    @IBOutlet weak var date: UILabel! {
        didSet {
            // Set `textColor` in code, because of iOS12 bug, where when
            // a custom color is selected in storyboard it cannot be changed.
            date.textColor = .primaryElement
        }
    }

    override var isHighlighted: Bool {
        didSet {
            date.textColor = isHighlighted ? .tertiaryElement : .primaryElement
        }
    }
}
