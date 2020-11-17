//
//  MoviesViewController.swift
//  Cinema
//
//  Created by Marius on 2020-08-01.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "moviesCell"

final class MoviesViewController: UICollectionViewController {
    private var datasource = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Invalidates layout to trigger `systemLayoutSizeFitting` method in `MoviesViewCell`.
        flowLayout?.invalidateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesViewCell

        cell.poster.image = UIImage(named: "networkImageViewDefault")!
        cell.title.text = String(repeating: "A", count: indexPath.row)

        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    private var flowLayout: UICollectionViewFlowLayout? {
        collectionViewLayout as? UICollectionViewFlowLayout
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Provides `collectionView` frame as target size for cell to size itself in `systemLayoutSizeFitting`.
        collectionView.frame.size
    }
}

extension MoviesViewController: DateViewControllerDelegate {
    func dateVC(_ dateVC: DateViewController, didUpdate datasource: [Movie]) {
        self.datasource = datasource
    }
}
