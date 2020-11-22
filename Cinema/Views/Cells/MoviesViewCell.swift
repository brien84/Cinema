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
        // Rounding down to workaround `the item height must be less than the height of the UICollectionView` warning message.
        // The message is probably a bug, since `targetSize` is `collectionView` frame and warning only occurs on iPhone 11 Pro Max.
        let height = targetSize.height.rounded(.down)

        // In order to prevent @IBDesignable storyboard crash, checks if `poster` outlet is nil.
        // Otherwise, `poster` will never be nil.
        let width = poster != nil ? poster.frame.height / 1.5 : targetSize.width / 1.1

        return CGSize(width: width, height: height)
    }
}
