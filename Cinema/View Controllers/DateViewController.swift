//
//  DateViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-29.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DateViewController: UITableViewController {
    private let datasource = Array(0...100)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView?.frame.size = moviesContainerSize
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

    }

    @IBAction private func rightNavigationBarButtonDidTap(_ sender: UIBarButtonItem) {

    }
}

extension DateViewController {
    private var moviesContainerSize: CGSize {
        let tableWidth = tableView.frame.width
        return CGSize(width: tableWidth, height: tableWidth * 0.9)
    }
}
