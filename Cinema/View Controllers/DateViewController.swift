//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DateViewController: UITableViewController {
    private let dateSelector: DateSelectable

    private let datasource = Array(0...10)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView?.frame.size = moviesContainerSize

        updateNavigationItemAppearance()
    }

    init(dateSelector: DateSelectable = DateSelector()) {
        self.dateSelector = dateSelector

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.dateSelector = DateSelector()

        super.init(coder: coder)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "showingCell", for: indexPath) as! DateShowingCell

        return cell
    }

    @IBAction private func leftNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        if dateSelector.isFirst {
            performSegue(withIdentifier: "openSettings", sender: nil)
        } else {
            dateSelector.previous()
            updateNavigationItemAppearance()
        }
    }

    @IBAction private func rightNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {
        dateSelector.next()
        updateNavigationItemAppearance()
    }

    private func updateNavigationItemAppearance() {
        navigationItem.title = dateSelector.current.asString(format: .monthAndDay)

        guard let leftButton = navigationItem.leftBarButtonItem else { return }
        leftButton.image = dateSelector.isFirst ? .options : .left
    }
}

extension DateViewController {
    private var moviesContainerSize: CGSize {
        let tableWidth = tableView.frame.width
        return CGSize(width: tableWidth, height: tableWidth * 1.2)
    }
}
