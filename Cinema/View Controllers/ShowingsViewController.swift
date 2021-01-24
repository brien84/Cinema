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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ShowingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == containersView || collectionView == datesView {
            return DateSelector.dates.count
        } else {
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == containersView {
            return collectionView.dequeueReusableCell(withReuseIdentifier: containerViewReuseID, for: indexPath)
        }

        if collectionView == datesView {
            return collectionView.dequeueReusableCell(withReuseIdentifier: datesViewReuseID, for: indexPath)
        }

        return UICollectionViewCell()
    }
}
