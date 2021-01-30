//
//  ShowingsViewContainerCell.swift
//  Cinema
//
//  Created by Marius on 2021-01-24.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

final class ShowingsViewContainerCell: UICollectionViewCell {
    @IBOutlet weak var timesView: UICollectionView!

    override func prepareForReuse() {
        super.prepareForReuse()

        tag = 0
        timesView.dataSource = nil
        timesView.delegate = nil
        timesView.backgroundView = nil
        timesView.contentOffset = .zero
    }
}
