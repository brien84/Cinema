//
//  DailyMoviesVC.swift
//  Cinema
//
//  Created by Marius on 2019-12-23.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DailyMoviesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var datasource = [Movie]() {
        didSet {
            datasource.sort { $0.title < $1.title }
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "DailyMoviesVCCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.backgroundColor = Constants.Colors.light
        
        flowLayout?.estimatedItemSize = CGSize(width: cellWidth, height: 1)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = datasource.count == 0 ? ErrorLabel(frame: collectionView.bounds, error: .noMovies) : nil
        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DailyMoviesVCCell
        
        let movie = datasource[indexPath.row]
        
        cell.title.text = movie.title
        cell.duration.text = movie.duration
        cell.ageRating.text = movie.ageRating
        cell.poster.url = movie.poster?.toURL()
        
        return cell
    }
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
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
        return self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    private var collectionViewWidth: CGFloat {
        return self.collectionView.bounds.width
    }

    private var itemsPerRow: CGFloat {
        return 2.0
    }
    
    private var inset: CGFloat {
        return self.collectionView.bounds.width * 0.03
    }
    
    private var cellWidth: CGFloat {
        return (collectionViewWidth - 3 * inset) / itemsPerRow
    }
}
