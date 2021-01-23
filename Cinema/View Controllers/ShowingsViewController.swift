//
//  ShowingsViewController.swift
//  Cinema
//
//  Created by Marius on 2021-01-23.
//  Copyright © 2021 Marius. All rights reserved.
//

import UIKit

final class ShowingsViewController: UIViewController {
    private let dates: DateSelectable

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
