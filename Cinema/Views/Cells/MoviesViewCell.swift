//
//  MoviesViewCell.swift
//  Cinema
//
//  Created by Marius on 2020-08-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

@IBDesignable
final class MoviesViewCell: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: CustomFontLabel!
    @IBOutlet private weak var titleContainer: UIView!

    @IBInspectable
    private var cornerRadius: CGFloat = 0 {
       didSet {
           layer.cornerRadius = cornerRadius
           layer.masksToBounds = cornerRadius > 0
       }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MoviesViewCell {
    // iOS 13+
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.systemLayoutSizeFitting(targetSize,
                                      withHorizontalFittingPriority: horizontalFittingPriority,
                                      verticalFittingPriority: verticalFittingPriority)

        return calculateCellSize(with: targetSize)
    }

    // iOS 12
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        super.systemLayoutSizeFitting(targetSize)

        return calculateCellSize(with: targetSize)
    }

    private func calculateCellSize(with targetSize: CGSize) -> CGSize {
        // Rounding down to workaround `the item height must be less than the height of the UICollectionView` warning message,
        // which occurs only on `iPhone 11 Pro Max` and `iPhone 12 Pro Max` devices, even though the height of cell is exact
        // height as `collectionView`.
        let height = targetSize.height.rounded(.down)

        let targetPosterHeight = height - titleContainer.frame.height
        let width = targetPosterHeight / 1.5

        return CGSize(width: width, height: height)
    }
}
