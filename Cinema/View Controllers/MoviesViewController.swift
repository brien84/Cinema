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
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
}
