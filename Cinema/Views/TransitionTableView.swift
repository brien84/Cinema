//
//  TransitionTableView.swift
//  Cinema
//
//  Created by Marius on 2020-12-19.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class TransitionTableView: UITableView {
    @IBOutlet private weak var headerMoviesLabel: CustomFontLabel!
    @IBOutlet private weak var headerContainerView: UIView!
    @IBOutlet private weak var headerShowingsLabel: CustomFontLabel!

    /// Returns true if`tableHeaderView` is completely under navigation bar.
    private var isTableHeaderViewVisible: Bool {
        guard let header = tableHeaderView else { return false }
        let distance = safeAreaInsets.top.distance(to: header.frame.maxY)
        return distance >= contentOffset.y
    }
}
