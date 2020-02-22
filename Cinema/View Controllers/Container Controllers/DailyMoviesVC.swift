//
//  DailyMoviesVC.swift
//  Cinema
//
//  Created by Marius on 2019-12-23.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class DailyMoviesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var datasource = [Movie]() {
        didSet {
            datasource.sort { $0.title < $1.title }
            collectionView.reloadData()
            flowLayout?.invalidateLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(DailyMoviesCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.contentInset.top = .segmentedControlHeight
        collectionView.contentInset.bottom = .inset

        collectionView.backgroundColor = .darkC

        flowLayout?.estimatedItemSize = CGSize(width: .cellWidth, height: 0.0)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = datasource.count == 0 ? ErrorLabel(.noMovies) : nil

        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DailyMoviesCell

        let movie = datasource[indexPath.row]

        cell.poster.url = movie.poster
        cell.title.text = movie.title
        cell.duration.text = movie.duration
        cell.ageRating.text = movie.ageRating

        return cell
    }

    // MARK: UICollectionViewFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .inset, left: .inset, bottom: 0, right: .inset)
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = datasource[indexPath.row]
        let vc = MovieViewController(with: movie)

        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DailyMoviesVC {
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
}

extension CGFloat {
    private static let itemsPerRow: CGFloat = 2
    fileprivate static let cellWidth: CGFloat = ((.screenWidth - 3 * .inset) / itemsPerRow).rounded(.towardZero)
    fileprivate static let inset: CGFloat = .screenWidth * 0.03
}
