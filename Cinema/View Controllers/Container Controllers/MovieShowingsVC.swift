//
//  MovieShowingsVC.swift
//  Cinema
//
//  Created by Marius on 29/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class MovieShowingsVC: UITableViewController {

    var datasource = [Showing]() {
        didSet {
            datasource.sort { $0.date < $1.date }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "UI-MovieShowingsTable"

        tableView.register(MovieShowingsCell.self, forCellReuseIdentifier: reuseIdentifier)

        tableView.contentInset.top = .segmentedControlHeight

        tableView.backgroundColor = .darkC
        tableView.separatorColor = .grayC

        // Hides separator lines of empty cells, if there aren't enought items to fill visible screen.
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieShowingsCell

        let showing = datasource[indexPath.row]

        cell.date.text = showing.date.asString(format: .monthAndDay)
        cell.time.text = showing.date.asString(format: .onlyTime)
        cell.venue.text = showing.venue
        cell.screenType.text = showing.is3D ? "3D" : nil

        return cell
    }
}
