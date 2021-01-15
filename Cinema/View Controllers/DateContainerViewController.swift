//
//  DateContainerViewController.swift
//  Cinema
//
//  Created by Marius on 2020-08-01.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "dateContainerViewCell"

final class DateContainerViewController: UICollectionViewController {
    private var datasource = [Movie]() {
        didSet {
            datasource.sort { $0.title < $1.title }
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set automatic cell sizing in code to improve Interface Builder stability.
        flowLayout?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DateContainerViewCell

        let movie = datasource[indexPath.row]

        cell.poster.url = movie.poster
        cell.title.text = movie.title

        return cell
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieVC" {
            guard let vc = segue.destination as? MovieDetailsViewController else { return }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }

            let movie = datasource[indexPath.row]
            vc.movie = movie
        }
    }
}

extension DateContainerViewController: UICollectionViewDelegateFlowLayout {
    private var flowLayout: UICollectionViewFlowLayout? {
        collectionViewLayout as? UICollectionViewFlowLayout
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Provides `collectionView` frame as target size for cell to size itself in `systemLayoutSizeFitting(_ targetSize:)`.
        collectionView.frame.size
    }
}

extension DateContainerViewController: DateViewControllerDelegate {
    func dateVC(_ dateVC: DateViewController, didUpdate datasource: [Movie]) {
        self.datasource = datasource
    }
}

extension DateContainerViewController: TransitionTableViewDelegate {
    func prepareForTransition(animated isAnimated: Bool, completion: (() -> Void)?) {
        // Scrolls to the beginning of the `collectionView`.
        if collectionView.contentOffset.x > 0 {
            collectionView.setContentOffset(.zero, animated: isAnimated)
            // Gives time for `setContentOffset` animation to finish.
            let delay = isAnimated ? .stdAnimation : 0.0

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion?()
            }
        } else {
            completion?()
        }
    }
}
