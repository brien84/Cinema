//
//  MoviesViewCell.swift
//  Cinema
//
//  Created by Marius on 2020-08-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MoviesViewCell: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!

    // iOS 13+
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        calculateCellSize(with: targetSize)
    }

    // iOS 12
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        calculateCellSize(with: targetSize)
    }
}

extension MoviesViewCell {
    private var cellWidth: CGFloat {
        poster.frame.height / 1.5
    }

    private func calculateCellSize(with targetSize: CGSize) -> CGSize {
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )

        return CGSize(width: cellWidth, height: size.height)
    }
}
