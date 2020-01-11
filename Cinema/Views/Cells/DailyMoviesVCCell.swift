//
//  DailyMoviesVCCell.swift
//  Cinema
//
//  Created by Marius on 2019-12-23.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DailyMoviesVCCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: NetworkImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    
    private lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.priority = UILayoutPriority(rawValue: 999)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
