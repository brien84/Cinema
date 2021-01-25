//
//  ShowingsViewController.swift
//  Cinema
//
//  Created by Marius on 2021-01-23.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

private let containerViewReuseID = "showingsViewContainerCell"
private let datesViewReuseID = "showingsViewDateCell"
private let timesViewReuseID = "showingsViewTimeCell"

final class ShowingsViewController: UIViewController {
    private let dates: DateSelectable

    @IBOutlet private weak var containersView: UICollectionView!
    @IBOutlet private weak var datesView: UICollectionView!

    required init?(coder: NSCoder) {
        self.dates = DateSelector()

        super.init(coder: coder)
    }

    init?(coder: NSCoder, dates: DateSelectable) {
        self.dates = dates

        super.init(coder: coder)
    }
}

extension ShowingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == containersView || collectionView == datesView {
            return DateSelector.dates.count
        }

        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == containersView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: containerViewReuseID, for: indexPath)
            // swiftlint:disable:next force_cast
            let containerCell = cell as! ShowingsViewContainerCell
            containerCell.tag = indexPath.row
            containerCell.timesView.dataSource = self
            containerCell.timesView.delegate = self

            return containerCell
        }

        if collectionView == datesView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: datesViewReuseID, for: indexPath)
            // swiftlint:disable:next force_cast
            let dateCell = cell as! ShowingsViewDateCell
            dateCell.date.text = DateSelector.dates[indexPath.row].asString(.monthAndDay)

            return dateCell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timesViewReuseID, for: indexPath)
        // swiftlint:disable:next force_cast
        let timeCell = cell as! ShowingsViewTimeCell
        timeCell.time.text = "16:20"

        return timeCell
    }
}

extension ShowingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            return UIEdgeInsets(top: 0, left: collectionView.frame.size.width / 4, bottom: 0, right: collectionView.frame.size.width / 4)
        default:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            return 8
        default:
            return 8
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            return 8
        default:
            return 8
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case containersView:
            return collectionView.frame.size
        case datesView:
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
        default:
            return CGSize(width: collectionView.frame.width / 2 - 12, height: collectionView.frame.width / 4)
        }
    }
}

extension ShowingsViewController: UIScrollViewDelegate {
    private func containersViewCenterIndexPath() -> IndexPath? {
        let point = CGPoint(x: containersView.bounds.midX, y: containersView.bounds.midY)
        return containersView.indexPathForItem(at: point)
    }

    private func datesViewCenterIndexPath() -> IndexPath? {
        let point = CGPoint(x: datesView.bounds.midX, y: datesView.bounds.midY)
        return datesView.indexPathForItem(at: point)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == containersView || scrollView == datesView else { return }
        guard let datesRow = datesViewCenterIndexPath()?.row else { return }
        guard let containerRow = containersViewCenterIndexPath()?.row else { return }

        if datesRow != containerRow {
            if scrollView == containersView {
                datesView.scrollToItem(at: IndexPath(item: containerRow, section: 0), at: .centeredHorizontally, animated: true)
            }

            if scrollView == datesView {
                containersView.scrollToItem(at: IndexPath(item: datesRow, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let collectionView: UICollectionView

        switch scrollView {
        case containersView:
            collectionView = containersView
        case datesView:
            collectionView = datesView
        default:
            return
        }

        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = collectionView.indexPathsForVisibleItems
        indexes.sort()
        guard var index = indexes.first else { return }
        guard let cell = collectionView.cellForItem(at: index) else { return }
        let position = collectionView.contentOffset.x - cell.frame.origin.x
        // TODO: ADJUST VALUE!!!
        if position > cell.frame.size.width / 1.75 {
            index.row += 1
        }

        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}
