//
//  ShowingsViewController.swift
//  Cinema
//
//  Created by Marius on 2021-01-23.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

private let datesViewReuseID = "showingsViewDateCell"

final class ShowingsViewController: UIViewController {
    private let dates: DateSelectable

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
        if collectionView == datesView {
            return DateSelector.dates.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: datesViewReuseID, for: indexPath) as? ShowingsViewDateCell {
            return cell
        }

        return UICollectionViewCell()
    }
}
