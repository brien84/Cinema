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

    private var tableSnapshot = UIView()
    private var containerSnapshot = UIView()
    private var moviesLabelSnapshot = UIView()
    private var showingsLabelSnapshot = UIView()

    /// Returns true if`tableHeaderView` is completely under navigation bar.
    private var isTableHeaderViewVisible: Bool {
        guard let header = tableHeaderView else { return false }
        let distance = safeAreaInsets.top.distance(to: header.frame.maxY)
        return distance >= contentOffset.y
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        tableHeaderView?.frame.size = CGSize(width: frame.width, height: frame.width * 1.25)
    }

    // MARK: - Snapshots

    private func snapshotTableView() -> UIView {
        let rect: CGRect

        if isTableHeaderViewVisible {
            guard let header = tableHeaderView else { return UIView() }
            let origin = CGPoint(x: header.bounds.minX, y: header.bounds.maxY)
            let size = CGSize(width: frame.width, height: bounds.maxY - header.bounds.maxY)
            rect = CGRect(origin: origin, size: size)
        } else {
            let origin = CGPoint(x: bounds.minX, y: bounds.minY + safeAreaInsets.top)
            let size = CGSize(width: frame.width, height: frame.height - safeAreaInsets.top)
            rect = CGRect(origin: origin, size: size)
        }

        if let snapshot = resizableSnapshotView(from: rect, afterScreenUpdates: true, withCapInsets: .zero) {
            snapshot.frame.origin.y = bounds.maxY - snapshot.frame.height
            return snapshot
        } else {
            return UIView()
        }
    }

    private func snapshotHeaderContainerView() -> UIView {
        if let snapshot = headerContainerView.snapshotView(afterScreenUpdates: true) {
            snapshot.frame.origin = headerContainerView.frame.origin
            return snapshot
        } else {
            return UIView()
        }
    }

    private func snapshotHeaderMoviesLabel() -> UIView {
        if let snapshot = headerMoviesLabel.snapshotView(afterScreenUpdates: true) {
            snapshot.frame.origin = headerMoviesLabel.frame.origin
            return snapshot
        } else {
            return UIView()
        }
    }

    private func snapshotHeaderShowingsLabel() -> UIView {
        if let snapshot = headerShowingsLabel.snapshotView(afterScreenUpdates: true) {
            snapshot.frame.origin = headerShowingsLabel.frame.origin
            return snapshot
        } else {
            return UIView()
        }
    }
}
