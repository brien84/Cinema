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
    var movie: Movie?
    private let dates = DateSelector.dates

    @IBOutlet private weak var poster: NetworkImageView!
    @IBOutlet private weak var containersView: UICollectionView!
    @IBOutlet private weak var datesView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        poster.url = movie?.poster
    }

    private func getShowings(on date: Date) -> [Showing] {
        guard let movie = movie else { return [] }
        let showings = movie.showings.filter { $0.isShown(on: date) }
        return showings.sorted()
    }
}

extension ShowingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == containersView || collectionView == datesView {
            return dates.count
        }

        // `ShowingsViewContainerCell` `timesView` collection view setup.
        guard let containerView = collectionView.superview?.superview else { return 0 }
        return getShowings(on: dates[containerView.tag]).count
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
            dateCell.date.text = dates[indexPath.row].asString(.monthAndDay)

            return dateCell
        }

        // `ShowingsViewContainerCell` `timesView` collection view setup.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timesViewReuseID, for: indexPath)
        // swiftlint:disable:next force_cast
        let timeCell = cell as! ShowingsViewTimeCell

        guard let containerView = collectionView.superview?.superview else { return timeCell }
        let showings = getShowings(on: dates[containerView.tag])
        timeCell.time.text = showings[indexPath.row].date.asString(.timeOfDay)
        timeCell.venue.text = showings[indexPath.row].venue
        timeCell.is3D = showings[indexPath.row].is3D

        return timeCell
    }
}

extension ShowingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case containersView:
            return collectionView.frame.size
        case datesView:
            return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
        default:
            return CGSize(width: collectionView.frame.width - 8 - 8, height: 500)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            /// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            let lol = collectionView.frame.width / 2 - (collectionView.frame.width / 2.5) / 2
            return UIEdgeInsets(top: 0, left: lol, bottom: 0, right: lol)
        default:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            return .zero
        default:
            return 8
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case containersView:
            return .zero
        case datesView:
            return .zero
        default:
            return 8
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
        if scrollView == containersView {
            targetContentOffset.pointee = scrollView.contentOffset
            guard let indexPath = containersViewCenterIndexPath() else { return }
            containersView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

        if scrollView == datesView {
            targetContentOffset.pointee = scrollView.contentOffset
            guard let indexPath = datesViewCenterIndexPath() else { return }
            datesView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
